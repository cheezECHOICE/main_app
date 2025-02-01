// import 'dart:convert';
// import 'dart:io';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:cheezechoice/upi_app.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// class PhonepePayment extends StatefulWidget {
//   const PhonepePayment({super.key});

//   @override
//   State<PhonepePayment> createState() => _PhonepePaymentState();
// }

// class _PhonepePaymentState extends State<PhonepePayment> {
//   @override
//   void initState() {
//     super.initState();

//     initPhonePeSdk();

//     body = getCheckSum().toString();
//   }

//   String body = "";
//   String callback = "flutterDemoApp";
//   String checksum = "";

//   Map<String, String> headers = {};
//   List<String> environmentList = <String>['SANDBOX', 'PRODUCTION'];
//   bool enableLogs = true;
//   Object? result;
//   String environmentValue = 'SANDBOX';
//   String appId = "";
//   String merchantId = "PGTESTPAYUAT143";
//   String packageName = "com.phonepe.app";
//   String apiEndPoint = "/pg/v1/pay";
//   String saltKey = "ab3ab177-b468-4791-8071-275c404d8ab0";
//   String saltIndex = "1";

//   void initPhonePeSdk() {
//     PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogs)
//         .then((isInitialized) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $isInitialized';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void isPhonePeInstalled() {
//     PhonePePaymentSdk.isPhonePeInstalled()
//         .then((isPhonePeInstalled) => {
//               setState(() {
//                 result = 'PhonePe Installed - $isPhonePeInstalled';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void isGpayInstalled() {
//     PhonePePaymentSdk.isGPayAppInstalled()
//         .then((isGpayInstalled) => {
//               setState(() {
//                 result = 'GPay Installed - $isGpayInstalled';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void isPaytmInstalled() {
//     PhonePePaymentSdk.isPaytmAppInstalled()
//         .then((isPaytmInstalled) => {
//               setState(() {
//                 result = 'Paytm Installed - $isPaytmInstalled';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void getPackageSignatureForAndroid() {
//     if (Platform.isAndroid) {
//       PhonePePaymentSdk.getPackageSignatureForAndroid()
//           .then((packageSignature) => {
//                 setState(() {
//                   result = 'getPackageSignatureForAndroid - $packageSignature';
//                 })
//               })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     }
//   }

//   void getInstalledUpiAppsForAndroid() {
//     PhonePePaymentSdk.getInstalledUpiAppsForAndroid()
//         .then((apps) => {
//               setState(() {
//                 if (apps != null) {
//                   Iterable l = json.decode(apps);
//                   List<UPIApp> upiApps = List<UPIApp>.from(
//                       l.map((model) => UPIApp.fromJson(model)));
//                   String appString = '';
//                   for (var element in upiApps) {
//                     appString +=
//                         "${element.applicationName} ${element.version} ${element.packageName}";
//                   }
//                   result = 'Installed Upi Apps - $appString';
//                 } else {
//                   result = 'Installed Upi Apps - 0';
//                 }
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void getInstalledUpiAppsForiOS() {
//     if (Platform.isIOS) {
//       PhonePePaymentSdk.getInstalledUpiAppsForiOS()
//           .then((apps) => {
//                 setState(() {
//                   result = 'getUPIAppsInstalledForIOS - $apps';

//                   // For Usage
//                   List<String> stringList = apps
//                           ?.whereType<
//                               String>() // Filters out null and non-String elements
//                           .toList() ??
//                       [];

//                   // Check if the string value 'Orange' exists in the filtered list
//                   String searchString = 'PHONEPE';
//                   bool isStringExist = stringList.contains(searchString);

//                   if (isStringExist) {
//                     print('$searchString app exist in the device.');
//                   } else {
//                     print('$searchString app does not exist in the list.');
//                   }
//                 })
//               })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     }
//   }

//   void getInstalledApps() {
//     if (Platform.isAndroid) {
//       getInstalledUpiAppsForAndroid();
//     } else {
//       getInstalledUpiAppsForiOS();
//     }
//   }

//   void startTransaction() async {
//     try {
//       PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
//           .then((response) => {
//                 setState(() {
//                   if (response != null) {
//                     String status = response['status'].toString();
//                     String error = response['error'].toString();
//                     if (status == 'SUCCESS') {
//                       result = "Flow Completed - Status: Success!";
//                     } else {
//                       result =
//                           "Flow Completed - Status: $status and Error: $error";
//                     }
//                   } else {
//                     result = "Flow Incomplete";
//                   }
//                 })
//               })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       handleError(error);
//     }
//   }

//   void handleError(error) {
//     setState(() {
//       if (error is Exception) {
//         result = error.toString();
//       } else {
//         result = {"error": error};
//       }
//     });
//   }

//   getCheckSum() {
//     final requestData = {
// //   "merchantId": merchantId,
// //   "merchantTransactionId": "MT7850590068188104",
// //   "merchantUserId": "MUID123",
// //   "amount": 10000,
// //   "callbackUrl": "https://webhook.site/95290922-ca19-4c76-a89d-fb15a93b1dc6",
// //   "mobileNumber": "9999999999",
// //   "paymentInstrument": {
// //     "type": "PAY_PAGE"
// //   }
// // };
//       "merchantId": merchantId,
//       "merchantTransactionId": "1234567890",
//       "merchantUserId": "n123",
//       "amount": 1000,
//       "mobileNumber": "7013491067",
//       "callbackUrl":
//           "https://webhook.site/2d6e647e-6440-44bb-8784-58e19c8a36b3",
//       "paymentInstrument": {"type": "PAY_PAGE", "targetApp": "com.phonepe.app"}
//     };

//     String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

//     checksum =
//         '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

//     return base64Body;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Payment"),
//         ),
//         body: ElevatedButton(
//           onPressed: startTransaction,
//           child: Text("Pay Now"),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cheezechoice/check.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "Enter amount", border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  PhonepePaymentGateway(context: context, amount: double.parse(textEditingController.text)).initializeSdk();
                },
                child: const Text("Check out"))
          ],
        ),
      ),
    );
  }
}


