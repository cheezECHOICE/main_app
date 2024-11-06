import 'package:flutter/material.dart';
import 'package:food/common/widgets/login_signup/form_divider.dart';
import 'package:food/common/widgets/login_signup/social_buttons.dart';
import 'package:food/features/authentication/screens/login/widgets/login_form.dart';
import 'package:food/features/authentication/screens/login/widgets/login_header.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/constants/text_strings.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Logo, Title and SubTitle
            TLoginHeader(),

            /// Form
            const SizedBox(height: TSizes.spaceBtwSections / 10),
            const TLoginForm(),
            const SizedBox(height: TSizes.spaceBtwSections / 2),

            //const SizedBox(height: 10),

            /// Logo and Powered By Text
            Column(
              children: [
                Image.asset(
                  'assets/logos/logo.png', 
                  height: 70,  
                  width: 70,     
                ),
                const SizedBox(height: 0),
                Text(
                  "Powered By Appe Nexus",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
