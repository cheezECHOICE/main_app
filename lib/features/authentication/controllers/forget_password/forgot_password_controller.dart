import 'package:flutter/material.dart';
import 'package:food/data/repositories/authentication_repo.dart';
import 'package:food/features/authentication/controllers/signup/network_manager.dart';
import 'package:food/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/popups/full_screen_loader.dart';
import 'package:food/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  ///Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  ///Send Reset Password
  sendPasswordResetEmail() async {
    try {
      ///Start loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.daceranimation);

      ///Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!forgotPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

//Send email to reset
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //showSuccess Screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password.'.tr);

      //Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Oh Snap', message: "Process failed! Kindly try again.");
    }
  }

  resendPasswordResendEmail(String email) async {
    try {
      ///Start loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.daceranimation);

      ///Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //showSuccess Screen
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password.'.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Oh Snap', message: "Process failed! Kindly try again.");
    }
  }
}
