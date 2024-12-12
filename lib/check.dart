import 'dart:convert' show base64Encode, jsonEncode, utf8;
import 'dart:developer';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/phonepe_payment.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonepePg {
  int amount;
  BuildContext context;

  PhonepePg({required this.context, required this.amount});
  String marchentId = "M22HEZTG4PPQA";
  String salt = "676835a1-a270-4ad0-926e-cf731976b6ac";
  int saltIndex = 1;
  String callbackURL = "https://api.phonepe.com/apis/hermes";
  String apiEndPoint = "/pg/v1/pay";

  init() {
    PhonePePaymentSdk.init("PRODUCTION", null, marchentId, true).then((val) {
      print('PhonePe SDK Initialized - $val');
      startTransaction();
    }).catchError((error) {
      print('PhonePe SDK error - $error');
      return <dynamic>{};
    });
  }
  
  startTransaction() {
    Map body = {
      "merchantId": marchentId,
      "merchantTransactionId": "MT${getRandomNumber()}",
      "merchantUserId": "asas", // login
      "amount": amount * 100, // paisa
      "callbackUrl": callbackURL,
      "mobileNumber": "9876543210", // login
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    //log(body.toString());
    // base64
    String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
    // checksum =
    // base64Body + apiEndPoint + salt
    var byteCodes = utf8.encode(bodyEncoded + apiEndPoint + salt);
    // sha256
    String checksum = "${sha256.convert(byteCodes)}###$saltIndex";
    PhonePePaymentSdk.startTransaction(bodyEncoded, callbackURL, checksum, "com.example.food")
        .then((success) {
      //log("Payment success ${success}");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (a) => CheckoutPage()), (e) => false);
    }).catchError((error) {
      //log("Payment failed $error");
    });
  }

  String getRandomNumber() {
    Random random = Random();
    String randomMerchant = "";
    for (int i = 0; i < 15; i++) {
      randomMerchant += random.nextInt(10).toString();
    }
    debugPrint("random Merchant>>>>> $randomMerchant");
    return randomMerchant;
  }
}
