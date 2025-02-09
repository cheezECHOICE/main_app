import 'package:flutter/material.dart';
import 'package:cheezechoice/utils/constants/colors.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Welcome Foodie",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: TColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your Email address for sign in. Enjoy your food :)",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}