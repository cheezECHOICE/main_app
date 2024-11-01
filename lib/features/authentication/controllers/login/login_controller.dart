import 'package:flutter/material.dart';
import 'package:food/data/repositories/authentication_repo.dart';
import 'package:food/features/authentication/controllers/signup/network_manager.dart';
import 'package:food/features/personalisation/controllers/user_controller.dart';
import 'package:food/navigation_menu.dart';
import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/local_storage/storage_utility.dart';
import 'package:food/utils/popups/full_screen_loader.dart';
import 'package:food/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  //variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    // Storing credentials
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  // Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.daceranimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is Selected
      if (!rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Login User using email and password Authentication
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      await userController.saveUserRecord(userCredentials);

      // Reset isLoggedOut flag
      localStorage.write('isLoggedOut', false);
      await TLocalStorage.init(userController.user.value.id);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      //Start loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.daceranimation);

      //Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google Authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      //Save User record
      await userController.saveUserRecord(userCredentials);

      // Reset isLoggedOut flag
      localStorage.write('isLoggedOut', false);
      await TLocalStorage.init(userController.user.value.id);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
