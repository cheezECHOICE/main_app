import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/data/repositories/user/user_repo.dart';
import 'package:cheezechoice/data/repositories/user/usermodel.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/network_manager.dart';
import 'package:cheezechoice/features/authentication/screens/signup/verify_email.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
import 'package:cheezechoice/utils/popups/full_screen_loader.dart';
import 'package:cheezechoice/utils/popups/loaders.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Password Validation Rules
  final passwordValidationRules = <String, bool>{
    "At least 6 characters": false,
    // "At least one uppercase letter": false,
    "At least one number": false,
    "At least one special character": false,
  }.obs;

  /// Variables
  final hidePassword = true.obs;
  final isTypingPassword = false.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  // final address = TextEditingController();
  var privacyPolicy = false.obs;
  // var address = ''.obs; 
  bool get isSignupEnabled => privacyPolicy.value;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); // formValidation

  // Validate all password rules
  bool areAllPasswordRulesValid() =>
      passwordValidationRules.values.every((isValid) => isValid);

  // Update password rules dynamically
  void updatePasswordRules(String value) {
    isTypingPassword.value = value.isNotEmpty;
    passwordValidationRules['At least 6 characters'] = value.length >= 6;
    // passwordValidationRules['At least one uppercase letter'] =
        // value.contains(RegExp(r'[A-Z]'));
    passwordValidationRules['At least one number'] =
        value.contains(RegExp(r'[0-9]'));
    passwordValidationRules['At least one special character'] =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  /// -- SIGNUP
  void signup() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Making your way to Foodie World...', TImages.mailanimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      final trimmedUsername = username.text.trim();
      final trimmedFirstName = firstName.text.trim();
      final trimmedLastName = lastName.text.trim();
      // final trimmedAddress = address.text.trim();

      if (!signupFormKey.currentState!.validate() ||
          _isFieldEmpty(trimmedUsername) ||
          _isFieldEmpty(trimmedFirstName) ||
          _isFieldEmpty(trimmedLastName) 
          // _isFieldEmpty(trimmedAddress)
          ) {
        TFullScreenLoader.stopLoading();
        TLoaders.customToast(
            message: "Please fill all required fields properly.");
        return;
      }

      // Privacy agreement
      if (!privacyPolicy.value) {
        TLoaders.customToast(
            message: "Please agree to the privacy policy to continue.");
        TFullScreenLoader.stopLoading();
        return;
      }

      // Check if email is already registered
      final emailExists = await AuthenticationRepository.instance
          .checkIfEmailExists(email.text.trim());
      if (emailExists) {
        TFullScreenLoader.stopLoading();
        TLoaders.customToast(
            message: "This email is already registered. Please log in.");
        return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Send email verification
      await userCredential.user?.sendEmailVerification();

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

      // Remove loader
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

  bool _isFieldEmpty(String value) {
    return value.trim().isEmpty;
  }
}