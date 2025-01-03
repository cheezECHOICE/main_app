import 'dart:async';

import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/order_type.dart';
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
    final brandController = Get.put(BrandController()); 
    final dark = THelperFunctions.isDarkMode(context);
    final isDialogActive = false.obs;

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
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Coupon Section
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Order Type Button
              Obx(() {
                final inCampusBrands = brandController.brandsToShow
                    .where((brand) => brand.inCampus!)
                    .toList();
                final hasInCampusBrand = inCampusBrands.isNotEmpty;

                return hasInCampusBrand
                    ? Column(
                        children: [
                          OrderTypeButton(),
                          const SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      )
                    : const SizedBox.shrink();
              }),

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
                    TBillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Divider(),
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
        child: Obx(() => ElevatedButton(
              onPressed: subtotal > 0 && !isDialogActive.value
                  ? () async {
                      isDialogActive.value = true; // Block the button
                      final isValid =
                          await orderController.validateCheckoutClauses();
                      if (isValid) {
                        _showConfirmationDialog(
                            context, orderController, isDialogActive);
                      } else {
                        isDialogActive.value = false; // Unblock on failure
                      }
                    }
                  : null, // Disable if the dialog is active
              child: Text(
                'Checkout ₹${TPricingCalculator.finalTotalPrice(subtotal, 'IND')}',
              ),
            )),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context,
      OrderController orderController, RxBool isDialogActive) {
    int mainCountdown = 10; // Countdown starts at 10 seconds
    bool isCanceled = false; // Flag to track if canceled
    Timer? mainTimer; // To manage the main timer

    // Show loader before opening the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context); // Close loader

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Checkout"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Start the main countdown timer
                if (mainTimer == null) {
                  mainTimer = Timer.periodic(
                    const Duration(seconds: 1),
                    (timer) {
                      if (mainCountdown > 0 && !isCanceled) {
                        setState(() {
                          mainCountdown--;
                        });
                      } else {
                        timer.cancel();
                        mainTimer = null; // Clear main timer reference
                        if (mainCountdown == 0 && !isCanceled) {
                          Navigator.pop(context); // Close dialog
                          orderController.processPrismaOrder(); // Process order
                          isDialogActive.value =
                              false; // Unblock checkout button
                        }
                      }
                    },
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("You have a few seconds to cancel your order."),
                    const SizedBox(height: 20),
                    Text(
                      "Placing order in $mainCountdown seconds...",
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
                  isCanceled = true; 
                  mainTimer?.cancel();
                  mainTimer = null; 
                  Navigator.pop(context); 
                  orderController.processPrismaOrder(); 
                  isDialogActive.value = false; 
                },
                child: const Text("Skip & proceed"),
              ),
              TextButton(
                onPressed: () {
                  isCanceled = true; 
                  mainTimer?.cancel(); 
                  mainTimer = null; 
                  Navigator.pop(context); 
                  isDialogActive.value = false;
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      ).then((_) {
        mainTimer?.cancel();
        mainTimer = null;
        isDialogActive.value = false; 
      });
    });
  }
}
