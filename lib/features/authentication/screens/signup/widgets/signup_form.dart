//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/features/authentication/controllers/signup/signup_controller.dart';
import 'package:food/features/authentication/screens/signup/widgets/terms_and_conditions_checkbox.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/constants/text_strings.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:food/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:food/features/authentication/screens/signup/verify_email.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // First and Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      TValidator.validateEmptyText('FirstName', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      TValidator.validateEmptyText('LastName', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///username
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                TValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
                labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///phone number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///password
          Obx(
            () => TextFormField(
              validator: (value) => TValidator.validatePassword(value),
              controller: controller.password,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          ///Terms
          const TTermsAndConditionsCheckBox(),
          const SizedBox(height: TSizes.spaceBtwSections),

          ///Signup button
          SizedBox(
            width: 300,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isSignupEnabled
                      ? () => controller.signup()
                      : () {
                          TLoaders.customToast(
                              message:
                                  "Please agree to the policy to continue");
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      controller.isSignupEnabled
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                  child: Text(
                    TTexts.createAccount,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: dark ? TColors.white : TColors.white,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
