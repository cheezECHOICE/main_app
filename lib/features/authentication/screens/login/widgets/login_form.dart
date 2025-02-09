import 'package:cheezechoice/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/controllers/login/login_controller.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/constants/text_strings.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = THelperFunctions.isDarkMode(context);
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Label
          const Text(
            "Email",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5), // Space between label and input field
          // Email Input Field
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.message_search4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: dark ? Colors.white : Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: TColors.primary, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 1.5),

          // Password Label
          const Text(
            "Password",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5), // Space between label and input field
          // Password Input Field
          Obx(
            () => TextFormField(
              validator: (value) => TValidator.validateEmptyText('Password', value),
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(
                    controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: dark ? Colors.white : Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: TColors.primary, width: 2.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Remember Me
                  Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                      )),
                  const Text(TTexts.rememberMe),
                ],
              ),

              // Forgot Password
              TextButton(
                onPressed: () => Get.to(const ForgotPassword()),
                child: const Text(TTexts.forgetPassword),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // SignIn Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => controller.emailAndPasswordSignIn(),
              child: const Text(
                TTexts.signIn,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Create Account Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Don't have an account?", style: TextStyle(fontSize: 12)),
              TextButton(
                onPressed: () => Get.to(SignupScreen()),
                child: const Text(
                  "Create new account.",
                  style: TextStyle(color: TColors.primary, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
