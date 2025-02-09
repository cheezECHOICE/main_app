import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/features/authentication/screens/signup/verifyotp.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/validators/validation.dart';

class OutsiderSignup extends StatefulWidget {
  @override
  _OutsiderSignupState createState() => _OutsiderSignupState();
}

class _OutsiderSignupState extends State<OutsiderSignup> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final AuthenticationRepository authRepo = AuthenticationRepository();

  bool otpSent = false;
  String? verificationId;

  void sendOtp() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.length == 10 &&
        RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      String fullPhoneNumber = "+91$phoneNumber";
      authRepo.sendOtp(fullPhoneNumber, (verificationId) {
        setState(() {
          otpSent = true;
          this.verificationId = verificationId;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid 10-digit phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Outsider Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              // Username
              TextFormField(
                controller: usernameController,
                validator: (value) =>
                    TValidator.validateEmptyText('Username', value),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email
              TextFormField(
                controller: emailController,
                validator: (value) => TValidator.validateEmail(value),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Phone Number with OTP
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                  prefixIcon: Icon(Icons.phone),
                  suffixIcon: TextButton(
                    onPressed: () {
                      sendOtp();
                    },
                    child: Text('Get OTP',
                        style: TextStyle(color: TColors.primary)),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              if (otpSent == true) ...[
                // OTP Input Field
                TextFormField(
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
              ],

              // Address
              TextFormField(
                controller: addressController,
                validator: (value) =>
                    TValidator.validateEmptyText('Address', value),
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) => TValidator.validatePassword(value),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signed Up Successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    return usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.length == 10 &&
        addressController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }
}
