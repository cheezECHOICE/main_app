import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/screens/login/widgets/login_form.dart';
import 'package:cheezechoice/features/authentication/screens/login/widgets/login_header.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('cheezECHOICE'),
        centerTitle: true,
        backgroundColor: dark ? TColors.dark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: TColors.primary),
      ),
      backgroundColor: dark ? TColors.dark : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// Logo, Title and SubTitle
              const TLoginHeader(),

              const SizedBox(height: TSizes.spaceBtwItems),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              const TLoginForm(),

              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Powered By and Logo
              Column(
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Powered By Appe Nexus",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}