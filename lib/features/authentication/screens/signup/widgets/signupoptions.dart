import 'package:cheezechoice/features/authentication/screens/signup/widgets/college_selection.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup.dart';
import 'package:cheezechoice/features/authentication/screens/signup/signup2.dart';
import 'package:get/get.dart';

class SignUpOptionPage extends StatelessWidget {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Order Your Feast',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to CheezECHOICE!\n Whether you\'re a hungry student or a local foodie, delicious meals are just a tap away. Let\'s get started!',
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
              onPressed: () => Get.to(() => SignupScreen()),
              child: Text('Order as a Student',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
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
              onPressed: () => Get.to(() => VerifyNumberScreen()),
              child: Text('Order as a Local',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }
}
