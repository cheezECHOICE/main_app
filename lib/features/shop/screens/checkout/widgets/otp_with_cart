import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:food/utils/constants/sizes.dart';

class CartDetailsWithOtpScreen extends StatelessWidget {
  const CartDetailsWithOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart Details',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Display all items in the cart
              const TCartItems(showAddRemoveButtons: true),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Divider
              const Divider(),

              // OTP Verification Section
              const OtpVerificationWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({super.key});

  @override
  _OtpVerificationWidgetState createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (index) => FocusNode());
    _controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      // Move to the next field when user enters a digit
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move back to the previous field when user presses backspace
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: dark ? Colors.black54 : Colors.white,
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // OTP Title
          Text(
            'Enter OTP',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.cyanAccent : Colors.deepPurple,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: dark ? Colors.cyan : Colors.deepPurpleAccent,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 50,
                child: RawKeyboardListener(
                  focusNode:
                      FocusNode(), // Add a focus node to listen for key events
                  onKey: (event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        _controllers[index].text.isEmpty &&
                        index > 0) {
                      // Move back to the previous field on backspace
                      _handleInput("", index);
                    }
                  },
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: dark ? Colors.cyanAccent : Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: dark ? Colors.black87 : Colors.white70,
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: dark ? Colors.cyan : Colors.deepPurpleAccent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: dark ? Colors.cyanAccent : Colors.deepPurple,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        _handleInput(value, index);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Verify Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: dark ? Colors.cyanAccent : Colors.deepPurple,
              shadowColor: dark ? Colors.cyan : Colors.deepPurpleAccent,
              elevation: 8,
            ),
            onPressed: () {
              // Handle OTP verification logic here
              String otp =
                  _controllers.map((controller) => controller.text).join();
              print(
                  "Entered OTP: $otp"); // Just a test, implement your verification here
            },
            child: Center(
              child: Text(
                'Verify OTP',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: dark ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}