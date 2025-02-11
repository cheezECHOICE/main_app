import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/constants/text_strings.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../../../common/widgets/loaders/loaders.dart';
import 'terms_and_conditions_checkbox.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());
    // const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
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
          // Username
          TextFormField(
            controller: controller.username,
            validator: (value) => TValidator.validateEmptyText('Name', value),
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),


          // TextFormField(
          //   controller: controller.address,
          //   validator: (value) => TValidator.validateEmptyText('Address', value),
          //   decoration: const InputDecoration(
          //     labelText: "Address",
          //     prefixIcon: Icon(Iconsax.user_edit),
          //   ),
          // ),
          

          // Address with Google Places
          // Address TextEditingController


// GooglePlaceAutoCompleteTextField(
//   textEditingController: controller.address,  // Use this controller
//   googleAPIKey: "AIzaSyBhFlq0nn0ExMa8-cjIqOSMk3F9bQEAmVk", 
//   inputDecoration: const InputDecoration(
//     labelText: 'Address',
//     prefixIcon: Icon(Icons.location_on),
//   ),
//   debounceTime: 400,
//   isLatLngRequired: false,
//   getPlaceDetailWithLatLng: (prediction) {
//     if (prediction.description != null) {
//       controller.address.value = prediction.description! as TextEditingValue;
//       controller.address.text = prediction.description!; // Set selected address
//     }
//     FocusScope.of(context).unfocus(); // Close keyboard and suggestions
//   },
// ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Obx(() {
                if (!controller.isTypingPassword.value) return const SizedBox.shrink();

                final allRulesSatisfied = controller.areAllPasswordRulesValid();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          allRulesSatisfied ? Icons.check_circle : Icons.info_outline,
                          color: allRulesSatisfied ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          allRulesSatisfied
                              ? "You are good to GO"
                              : "Password must meet the following rules:",
                          style: TextStyle(
                            color: allRulesSatisfied ? Colors.green : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    if (!allRulesSatisfied)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.passwordValidationRules.entries.map((rule) {
                          final isValid = rule.value;
                          return Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 4.0),
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

          // Terms
          const TTermsAndConditionsCheckBox(),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Signup Button
          SizedBox(
            width: 300,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isSignupEnabled
                      ? () => controller.signup()
                      : () {
                          TLoaders.customToast(
                              message: "Please agree to the policy to continue");
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      controller.isSignupEnabled ? TColors.primary : Colors.grey,
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