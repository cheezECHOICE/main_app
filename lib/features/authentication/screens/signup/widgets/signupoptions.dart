import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup2.dart';
import 'package:get/get.dart';

class SignUpOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Us!'),
        backgroundColor: Color(0xFF935EB2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Your Path',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We are excited to have you on board! Whether you are a student or an outsider, we have something special for you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF935EB2), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () => Get.to(()=>SignupScreen()),
              child: Text('Student Sign Up', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF935EB2), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () => Get.to(()=>PhoneNumberInput()),
              child: Text('Outsider Sign Up', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}