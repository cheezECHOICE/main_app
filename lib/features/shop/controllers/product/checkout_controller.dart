import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/texts/section_heading.dart';
import 'package:cheezechoice/features/shop/models/payment_method_model.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();
  final Rx<PaymentMethodModel> selectedPaymentMethod = paymentMethods[0].obs;

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(
                  title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Paypal', image: TImages.paypal)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Google Pay', image: TImages.googlePay)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Apple Pay', image: TImages.applePay)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod:
                      PaymentMethodModel(name: 'VISA', image: TImages.visa)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Master Card', image: TImages.masterCard)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod:
                      PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Paystack', image: TImages.paystack)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              TPaymentTile(
                  paymentMethod: PaymentMethodModel(
                      name: 'Credit Card', image: TImages.creditCard)),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
