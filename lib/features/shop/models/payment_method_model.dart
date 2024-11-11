import 'package:cheezechoice/utils/constants/image_strings.dart';

class PaymentMethodModel {
  String name;
  String image;

  PaymentMethodModel({required this.image, required this.name});

  static PaymentMethodModel empty() => PaymentMethodModel(image: '', name: '');
}

List<PaymentMethodModel> paymentMethods = [
  // PaymentMethodModel(image: TImages.paytm, name: 'Paytm'),
  // PaymentMethodModel(image: TImages.razorPay, name: 'RazorPay'),
  PaymentMethodModel(image: TImages.cod, name: 'Cash On Delivery')
];
