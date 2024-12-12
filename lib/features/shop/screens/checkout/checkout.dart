import 'dart:async';

import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/styles/TRoundedContainer.dart';
import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
import 'package:cheezechoice/common/widgets/products/cart/coupon_widget.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/select_addresses.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';

import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final subtotal = cartController.totalCartPrice.value;
    final orderController = Get.put(OrderController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Order Review',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Displaying Items in Cart (without add/remove buttons)
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Coupon Section
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Delivery Address Section
              DeliveryAddressSection2(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Billing Information
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    /// Pricing Details
                    TBillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwSections),

                    /// Divider
                    Divider(),

                    /// Payment Method
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subtotal > 0
              ? () async {
                  final isValid =
                      await orderController.validateCheckoutClauses();
                  if (isValid) {
                    _showConfirmationDialog(context, orderController);
                  }
                }
              : () => TLoaders.warningSnackBar(
                  title: 'Empty Cart',
                  message: 'Add items in the cart in order to proceed.'),
          child: Obx(() => Text(
              'Checkout ₹${TPricingCalculator.finalTotalPrice(subtotal, 'IND')}')),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, OrderController orderController) {
    int countdown = 10; // Grace period in seconds
    bool isCanceled = false; // To track cancellation

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Checkout"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Start countdown when the dialog opens
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0 && !isCanceled) {
                  setState(() => countdown--);
                } else if (countdown == 0 && !isCanceled) {
                  Navigator.pop(context); // Close the dialog
                  orderController.processPrismaOrder(); // Proceed with checkout
                }
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("You have a few seconds to cancel your order."),
                  const SizedBox(height: 20),
                  Text(
                    "Placing order in $countdown seconds...",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                isCanceled = true; // Mark as canceled
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
