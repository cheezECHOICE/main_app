import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
// import 'package:cheezechoice/common/widgets/login_signup/form_divider.dart';
// import 'package:cheezechoice/common/widgets/login_signup/social_buttons.dart';
import 'package:cheezechoice/features/authentication/screens/signup/widgets/signup_form.dart';
//import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/constants/text_strings.dart';
// import 'package:get/get.dart';
//import 'package:iconsax/iconsax.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///Form
            const TSignupForm(),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ///Divider
            // TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
            // const SizedBox(height: TSizes.spaceBtwSections / 1.5),

            // ///Social Buttons
            // const TSocialButtons(),

            // const SizedBox(height: 24),
            Center(
              child: Text(
                "Powered By Appe Nexus",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
