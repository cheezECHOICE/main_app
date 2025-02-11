import 'dart:io';

import 'package:cheezechoice/features/authentication/screens/signup/verify_email.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
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

  Future<void> createPrismaUser(
      String uid, String name, String email, String phoneNumber) async {
    try {
      await Dio().post('$dbLink/user', data: {
        "id": uid,
        "name": name,
        "email": email,
        "phoneno": phoneNumber,
      });
    } catch (e) {
      if (kDebugMode) print('Prisma Error: $e');
    }
  }

  /// Function to Show Relevant Screen
  void screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      await TLocalStorage.init(user.uid);
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
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
  //   deviceStorage.read('isFirstTime') != true
  //       ? Get.off(() => LoginScreen())
  //       : Get.off(() => const OnBoardingScreen());
  // }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      // Fetch sign-in methods for the provided email
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);

      // If the list is not empty, it means the email is already registered with one or more methods
      return signInMethods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      // Handle specific exceptions related to authentication if necessary
      if (e.code == 'invalid-email') {
        // The email is badly formatted or invalid
        throw ('Invalid email format.');
      }
      // If other errors occur, rethrow them
      rethrow;
    } catch (e) {
      // Handle any other errors
      print('Error in checking email existence: $e');
      rethrow;
    }
  }

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

      // Create Prisma user
      // await createPrismaUser(
      //   userCredential.user!.uid,
      //   //'${controller.user.value.fullName}',
      //   '${userCredential.user!.displayName ?? 'User'}',
      //   email,
      //   userCredential.user!.phoneNumber ?? '',
      // );
      var signupController = SignupController.instance;
      await createPrismaUser(
        userCredential.user!.uid,
        '${signupController.username.text.trim()}', // Accessing username through the controller
        email,
        signupController.phoneNumber.text.trim()
        // '${signupController.address.text.trim()}' 
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
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create Prisma user
      await createPrismaUser(
        userCredential.user!.uid,
        googleUser.displayName ?? 'User',
        googleUser.email,
        userCredential.user!.phoneNumber ?? '',
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
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

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

  // Method to send OTP
  Future<void> sendOtp(
      String phoneNumber, Null Function(dynamic verificationId) param1) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store the verification ID for later use
        // Navigate to OTP input screen
        deviceStorage.write('verificationId', verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
      },
    );
  }

  // Method to verify OTP
  Future<void> verifyOtp(String verificationId, String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await auth.signInWithCredential(credential);
      // Handle successful verification
    } catch (e) {
      // Handle error
      print('Verification failed: $e');
    }
  }
}
