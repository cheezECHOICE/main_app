import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/controllers/login/login_controller.dart';
import 'package:cheezechoice/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/constants/text_strings.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = THelperFunctions.isDarkMode(context);
    return Form(
      key: controller.loginFormKey,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : Colors.white,
          //dark ? TColors.primary.withOpacity(0.1)  : TColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.3),
              //dark ? TColors.primary.withOpacity(0.1) : TColors.primary.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, 0),
            ),
          ],
        ),
        width: THelperFunctions.screenWidth() * 0.9,
        child: Column(
          children: [
            // Email
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: controller.email,
                validator: (value) => TValidator.validateEmail(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.message_search4),
                  labelText: TTexts.email,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: dark ? Colors.white : Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: dark ? Colors.white : Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 1.5),
            // Password
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Obx(
                () => TextFormField(
                  validator: (value) =>
                      TValidator.validateEmptyText('Password', value),
                  controller: controller.password,
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: TTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(
                        controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: dark ? Colors.white : Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: dark ? Colors.white : Colors.black,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value,
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
              width: THelperFunctions.screenWidth() * 0.35,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems * 1.5),

            const Text("Don't have an account?",
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: TSizes.spaceBtwItems*0.5),
            SizedBox(
              height: 35,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:WidgetStateProperty.all(Color(0xFF935EB2).withOpacity(0.3)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),

                onPressed: () => Get.to(const SignupScreen()),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const Text(
                  TTexts.signup,
                  style: TextStyle(fontSize: 13,color: Colors.white),

                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
