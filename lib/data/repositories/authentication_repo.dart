import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cheezechoice/address_selection.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:cheezechoice/data/repositories/user/user_repo.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cheezechoice/features/authentication/screens/login/login.dart';
import 'package:cheezechoice/features/authentication/screens/onboarding/onboarding.dart';
import 'package:cheezechoice/launching.dart';
import 'package:cheezechoice/utils/constants/api_constants.dart';
import 'package:cheezechoice/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:cheezechoice/utils/exceptions/firebase_exception.dart';
import 'package:cheezechoice/utils/exceptions/format_exception.dart';
import 'package:cheezechoice/utils/exceptions/paltform_exception.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;
  

  /// Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  String generateUID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(20, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> createPrismaUser(
      String uid, String name, String email, String phoneNumber,String password) async {
    try {
      await Dio().post('$dbLink/user', data: {
        "id": uid,
        "name": name,
        "email": email,
        "phoneno": phoneNumber,
        "password":password
      });
    } catch (e) {
      if (kDebugMode) print('Prisma Error: $e');
    }
  }

  /// Function to Show Relevant Screen
  void screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      // await TLocalStorage.init(user.uid);
      // if (user.emailVerified) {
        Get.offAll(() => LocationSearchScreen());
      // } else {
      //   Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      // }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.off(() => const LoginScreen())
          : Get.off(() => const OnBoardingScreen());
    }
  }
  // void screenRedirect() async {
  //   deviceStorage.writeIfNull('isFirstTime', true);
  //     deviceStorage.read('isFirstTime') != true
  //         ? Get.off(() => LoginScreen())
  //         : Get.off(() => const OnBoardingScreen());
  // }

  //[EmailAuthentication] - LogIn
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  //[EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      var signupController = SignupController.instance;
      await createPrismaUser(
        userCredential.user!.uid,
        '${signupController.username.text.trim()}', 
        email,
        signupController.phoneNumber.text
            .trim(),
        signupController.password.text.trim(), // Accessing phone number through the controller
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


Future<void> loginWithPhoneAndPassword(String phoneno, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$dbLink/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneno': phoneno, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    print('🔹 Response Status Code: ${response.statusCode}');
    print('🔹 Response Body: ${response.body}');

    if (response.statusCode == 200 && responseData['status'] == 200) {
      // ✅ Store Token in GetX Controller
      final token = responseData['data']['token'] ?? '';
      final userId = responseData['data']['userId'] ?? '';

      AuthController.instance.setAuthData(token, userId);

      print('✅ Login Successful: User ID = $userId');
    } else {
      print('❌ Login Failed: ${responseData['message']}');
      throw responseData['message'] ?? 'Login failed';
    }
  } catch (e, stackTrace) {
    print('❌ Exception: $e');
    print('🛠️ Stack Trace: $stackTrace');
    throw 'Something went wrong. Please try again';
  }
}




Future<void> registerWithPrisma() async {
  try {
    var signupController = SignupController.instance;
    String uid = generateUID();

    // Call Prisma API
    await createPrismaUser(
      uid,
      signupController.username.text.trim(),
      signupController.email.text.trim(),
      signupController.phoneNumber.text.trim(),
      signupController.password.text.trim(),
    );

    AuthController.instance.setAuthData('',uid);
  } catch (e) {
    debugPrint('[registerWithPrisma] Error: $e');
    throw 'Something went wrong. Please try again';
  }
}




  /// [EmailVerification] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] -Forgot
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ReAuthenticate] - Re AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailandPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [GoogleAuthenticatiom] - Google
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       // The user canceled the sign-in
  //       return null;
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the Google credential
  //     final userCredential = await _auth.signInWithCredential(credential);

  //     // Create Prisma user
  //     await createPrismaUser(
  //       userCredential.user!.uid,
  //       googleUser.displayName ?? 'User',
  //       googleUser.email,
  //       userCredential.user!.phoneNumber ?? '',
  //     );

  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     throw TFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     if (kDebugMode) print('Something went wrong: $e');
  //     return null;
  //   }
  // }

  // Logout user
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete user
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Upload Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}


class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  var authToken = ''.obs;
  var userId = ''.obs;

  void setAuthData(String token, String id) {
    authToken.value = token;
    userId.value = id;
  }

  void clearAuthData() {
    authToken.value = '';
    userId.value = '';
  }
}