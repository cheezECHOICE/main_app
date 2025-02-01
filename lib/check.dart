// import 'dart:convert' show base64Encode, jsonEncode, utf8;
// import 'dart:developer';
// import 'dart:math';

// import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:cheezechoice/phonepe_payment.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// class PhonepePg {
//   double amount;
//   BuildContext context;

//   PhonepePg({required this.context, required this.amount});
//   String PROD_URL = 'https://api.phonepe.com/apis/hermes/pg/v1/';
//   String marchentId = "M22HEZTG4PPQA";
//   String salt = "676835a1-a270-4ad0-926e-cf731976b6ac";
//   int saltIndex = 1;
//   String callbackURL = "https://api.phonepe.com/apis/hermes";
//   String apiEndPoint = "/pg/v1/pay";

//   init() {
//     PhonePePaymentSdk.init("PRODUCTION", null, marchentId, true).then((val) {
//       print('PhonePe SDK Initialized - $val');
//       startTransaction();
//     }).catchError((error) {
//       print('PhonePe SDK error - $error');
//       return <dynamic>{};
//     });
//   }
  
//   startTransaction() {
//     Map body = {
//       "merchantId": marchentId,
//       "merchantTransactionId": "MT${getRandomNumber()}",
//       "merchantUserId": "asas", // login
//       "amount": amount * 100, // paisa
//       "callbackUrl": callbackURL,
//       "mobileNumber": "", // login
//       "paymentInstrument": {"type": "PAY_PAGE"}
//     };
//     //log(body.toString());
//     // base64
//     String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
//     // checksum =
//     // base64Body + apiEndPoint + salt
//     var byteCodes = utf8.encode(bodyEncoded + apiEndPoint + salt);
//     // sha256
//     String checksum = "${sha256.convert(byteCodes)}###$saltIndex";
//     PhonePePaymentSdk.startTransaction(bodyEncoded, callbackURL, checksum, "com.example.food")
//         .then((success) {
//       //log("Payment success ${success}");
//       Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (a) => CheckOutScreen()), (e) => false);
//     }).catchError((error) {
//       //log("Payment failed $error");
//       Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (a) => CheckOutScreen()), (e) => false);
//     });
//   }

//   String getRandomNumber() {
//     Random random = Random();
//     String randomMerchant = "";
//     for (int i = 0; i < 15; i++) {
//       randomMerchant += random.nextInt(10).toString();
//     }
//     debugPrint("random Merchant>>>>> $randomMerchant");
//     return randomMerchant;
//   }
// }

import 'dart:convert' show base64Encode, jsonEncode, utf8;
import 'dart:developer';
import 'dart:math' hide log;

import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonepePaymentGateway {
  final double amount;
  final BuildContext context;

  // Configuration values
  static const String _prodUrl = 'https://api.phonepe.com/apis/hermes';
  static const String _merchantId = "M22HEZTG4PPQA";
  static const String _salt = "676835a1-a270-4ad0-926e-cf731976b6ac"; 
  static const int _saltIndex = 1; 
  static const String _callbackUrl = '';
  static const String _apiEndpoint = '/pg/v1/pay';

  PhonepePaymentGateway({
    required this.context,
    required this.amount,
  });

  /// Initialize the PhonePe SDK
  Future<void> initializeSdk() async {
    try {
      bool isInitialized = await PhonePePaymentSdk.init(
        "PRODUCTION",
        null,
        _merchantId,
        true,
      );
      log('PhonePe SDK Initialized: $isInitialized');
      if (isInitialized) {
        startTransaction();
      } else {
        log('Failed to initialize PhonePe SDK');
        showErrorSnackbar('Failed to initialize PhonePe SDK');
      }
    } catch (error) {
      log('Error initializing PhonePe SDK: $error');
      showErrorSnackbar('Error initializing payment gateway.');
    }
  }

  /// Start a payment transaction
  Future<void> startTransaction() async {
    try {
      String transactionId = generateTransactionId();
      Map<String, dynamic> body = _buildRequestPayload(transactionId);
      String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
      String checksum = _generateChecksum(bodyEncoded);

      Map? success = await PhonePePaymentSdk.startTransaction(
        bodyEncoded,
        _callbackUrl,
        checksum,
        "com.appenexus.cheezechoice",
      );

      if (success != null) {
        log('Payment successful');
        _navigateToCheckout();
      } else {
        log('Payment failed');
        _navigateToCheckout();
      }
    } catch (error) {
      log('Error during transaction: $error');
      showErrorSnackbar('Payment failed. Please try again.');
      _navigateToCheckout();
    }
  }

  /// Build the request payload
  Map<String, dynamic> _buildRequestPayload(String transactionId) {
    return {
      "merchantId": _merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "user123", // Replace with actual user ID
      "amount": (amount * 100).toInt(), // Convert to paisa
      "callbackUrl": _callbackUrl,
      "mobileNumber": "9876543210", // Replace with actual mobile number
      "paymentInstrument": {"type": "PAY_PAGE"},
    };
  }

  /// Generate a checksum for the payload
  String _generateChecksum(String bodyEncoded) {
    var byteCodes = utf8.encode('$bodyEncoded$_apiEndpoint$_salt');
    return "${sha256.convert(byteCodes)}###$_saltIndex";
  }

  /// Generate a random transaction ID
  String generateTransactionId() {
    Random random = Random();
    return List.generate(15, (_) => random.nextInt(10).toString()).join();
  }

  /// Navigate to the checkout screen
  void _navigateToCheckout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => CheckOutScreen()),
      (route) => false,
    );
  }

  /// Show an error snackbar
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

