import 'package:flutter/material.dart';
import 'package:food/features/authentication/controllers/login/login_controller.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final isDarkMode = THelperFunctions.isDarkMode(context);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => controller.googleSignIn(),
          borderRadius: BorderRadius.circular(20), 
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Image(
                  width: TSizes.iconMd,
                  height: TSizes.iconLg,
                  image: AssetImage(TImages.google),
                ),
                const SizedBox(width: 10),
                Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: textColor, // Adjust the color based on the theme
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
