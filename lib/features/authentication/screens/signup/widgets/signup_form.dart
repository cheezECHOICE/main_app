//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cheezechoice/features/authentication/screens/signup/widgets/terms_and_conditions_checkbox.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/constants/text_strings.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:cheezechoice/features/authentication/screens/signup/verify_email.dart';

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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Password Input Field
              Obx(() => TextFormField(
                    controller: controller.password,
                    obscureText: controller.hidePassword.value,
                    onChanged: (value) {
                      controller.updatePasswordRules(value);
                    },
                    validator: (value) => controller.areAllPasswordRulesValid()
                        ? null
                        : 'Password does not meet the requirements',
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye),
                      ),
                    ),
                  )),

              const SizedBox(height: 10),

              // Password Rules with Dynamic Header
              Obx(() {
                if (!controller.isTypingPassword.value)
                  return const SizedBox.shrink();

                final allRulesSatisfied = controller.areAllPasswordRulesValid();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          allRulesSatisfied
                              ? Icons.check_circle
                              : Icons.info_outline,
                          color: allRulesSatisfied ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          allRulesSatisfied
                              ? "P̶a̶s̶s̶w̶o̶r̶d̶ m̶u̶s̶t̶ m̶e̶e̶t̶ t̶h̶e̶ f̶o̶l̶l̶o̶w̶i̶n̶g̶ r̶u̶l̶e̶s̶:̶"
                              : "Password must meet the following rules:",
                          style: TextStyle(
                            color: allRulesSatisfied
                                ? Colors.green
                                : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Display Password Rules
                    if (!allRulesSatisfied)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.passwordValidationRules.entries
                            .map((rule) {
                          final isValid = rule.value;
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  isValid ? Icons.check_circle : Icons.cancel,
                                  color: isValid ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  rule.key,
                                  style: TextStyle(
                                    color: isValid ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwSections),

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
 // P̶a̶s̶s̶w̶o̶r̶d̶ m̶u̶s̶t̶ m̶e̶e̶t̶ t̶h̶e̶ f̶o̶l̶l̶o̶w̶i̶n̶g̶ r̶u̶l̶e̶s̶:̶