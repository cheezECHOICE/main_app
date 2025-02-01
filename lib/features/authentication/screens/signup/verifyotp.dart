import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final String verificationId;
  final AuthenticationRepository authRepo = AuthenticationRepository();

  OtpInput({required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final smsCode = otpController.text.trim();
                if (smsCode.isNotEmpty) {
                  authRepo.verifyOtp(verificationId, smsCode);
                } else {
                  // Show error message
                  print('Please enter the OTP');
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}