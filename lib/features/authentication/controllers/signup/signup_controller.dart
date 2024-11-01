import 'package:flutter/material.dart';
import 'package:food/data/repositories/authentication_repo.dart';
import 'package:food/data/repositories/user/user_repo.dart';
import 'package:food/data/repositories/user/usermodel.dart';
import 'package:food/features/authentication/controllers/signup/network_manager.dart';
import 'package:food/features/authentication/screens/signup/verify_email.dart';
import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/local_storage/storage_utility.dart';
import 'package:food/utils/popups/full_screen_loader.dart';
import 'package:food/utils/popups/loaders.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); // formValidation

  /// -- SIGNUP
  void signup() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Making your way Foodie World...', TImages.mailanimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create an account you must have read and accept the Privacy Policy & Terms of Use.',
        );
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());
      // Save Authenticated user data in the Firebase Firestore
      final newuser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newuser);

      await TLocalStorage.init(userCredential.user!.uid);

      //Remove loader
      TFullScreenLoader.stopLoading();
      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(
          title: 'Oh Snap!', message: "Sign Up failed, please retry again!");
    }
  }
}
