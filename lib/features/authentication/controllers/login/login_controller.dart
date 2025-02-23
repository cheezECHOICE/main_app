import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/network_manager.dart';
import 'package:cheezechoice/features/personalisation/controllers/user_controller.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
import 'package:cheezechoice/utils/popups/full_screen_loader.dart';
import 'package:cheezechoice/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  //variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  // final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    // Storing credentials
    // email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    phone.text = localStorage.read('REMEMBER_ME_PHONE') ?? '';
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
      if (rememberMe.value) {
        // localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Login User using email and password Authentication
      // final userCredentials = await AuthenticationRepository.instance
      //     .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // await userController.saveUserRecord(userCredentials);

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


Future<void> phoneAndPasswordSignIn() async {
  try {
    // Start Loading
    TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.daceranimation);

    // Check Internet Connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading();
      return;
    }

    // Form Validation
    if (!loginFormKey.currentState!.validate()) {
      TFullScreenLoader.stopLoading();
      return;
    }

    // Save Data if Remember Me is Selected
    if (rememberMe.value) {
      localStorage.write('REMEMBER_ME_PHONE', phone.text.trim());
      localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
    } else {
      localStorage.remove('REMEMBER_ME_PHONE');
      localStorage.remove('REMEMBER_ME_PASSWORD');
    }

    // Call Login API
    await AuthenticationRepository.instance.loginWithPhoneAndPassword(
      phone.text.trim(),
      password.text.trim(),
    );

    // Reset isLoggedOut flag
    localStorage.write('isLoggedOut', false);
    await TLocalStorage.init(userController.user.value.id);

// await GetStorage.init();
    // Remove Loader
    TFullScreenLoader.stopLoading();
    Get.offAll(() => const NavigationMenu());
    
  } catch (e) {
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
  }
}
}
