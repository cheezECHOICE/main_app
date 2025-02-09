import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollegeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('VIT-AP'),
              onTap: () {
                // Navigate to SignUpOptionPage with selected college
                Get.to(() => SignupScreen());
              },
            ),
            ListTile(
              title: Text('SRM-AP'),
              onTap: () {
                // Navigate to SignUpOptionPage with selected college
                Get.to(() => SignupScreen());
              },
            ),
            // Add more colleges as needed
          ],
        ),
      ),
    );
  }
}
