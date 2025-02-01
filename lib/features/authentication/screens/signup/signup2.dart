import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/features/authentication/screens/signup/verifyotp.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final AuthenticationRepository authRepo = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  authRepo.sendOtp(phoneNumber, (verificationId) {
                    // Navigate to OTP input screen with the verification ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpInput(verificationId: verificationId),
                      ),
                    );
                  });
                } else {
                  // Show error message
                  print('Please enter a valid phone number');
                }
              },
              child: Text('Get OTP'),
            ),
          ],
        ),
      ),
    );
  }
}