import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/features/authentication/controllers/signup/signup_controller.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/constants/text_strings.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class TTermsAndConditionsCheckBox extends StatefulWidget {
  const TTermsAndConditionsCheckBox({Key? key}) : super(key: key);

  @override
  _TTermsAndConditionsCheckBoxState createState() =>
      _TTermsAndConditionsCheckBoxState();
}

class _TTermsAndConditionsCheckBoxState
    extends State<TTermsAndConditionsCheckBox> {
  final controller = SignupController.instance;

  late String localPrivacyPath;
  late String localTermsPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalFiles();
  }

  // Asynchronously load the local files from assets to the temporary directory
  Future<void> _loadLocalFiles() async {
    try {
      final directory = await getTemporaryDirectory();

      // Load Privacy Policy
      final privacyPolicyData =
          await rootBundle.load('assets/docs/privacy_policy.pdf');
      final privacyPolicyFile = File('${directory.path}/privacy_policy.pdf');
      await privacyPolicyFile
          .writeAsBytes(privacyPolicyData.buffer.asUint8List());
      localPrivacyPath = privacyPolicyFile.path;

      // Load Terms and Conditions
      final termsData = await rootBundle.load('assets/docs/T_C.pdf');
      final termsFile = File('${directory.path}/T_C.pdf');
      await termsFile.writeAsBytes(termsData.buffer.asUint8List());
      localTermsPath = termsFile.path;

      setState(() {
        isLoading = false; // Files are loaded
      });
    } catch (e) {
      print('Error loading local files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) =>
                  controller.privacyPolicy.value = value ?? false,
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwInputFields / 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${TTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${TTexts.privacyPolicy} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? TColors.white : TColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? TColors.white : TColors.primary,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => _showFullScreenDocument(context, localPrivacyPath),
              ),
              TextSpan(
                text: '${TTexts.and} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: TTexts.termsOfUse,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? TColors.white : TColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? TColors.white : TColors.primary,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => _showFullScreenDocument(context, localTermsPath),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to open the document in a full-screen view
  void _showFullScreenDocument(BuildContext context, String filePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            automaticallyImplyLeading: false,
            title: const Text('Policies'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: PDFView(
            filePath: filePath,
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
