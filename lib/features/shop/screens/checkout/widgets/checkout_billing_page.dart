import 'package:flutter/material.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:food/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:food/utils/helpers/pricing_calculator.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider

import '../../../../../utils/constants/colors.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final dark = THelperFunctions.isDarkMode(context);

    final cartController = CartController.instance;
    final subtotal = cartController.totalCartPrice.value;

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title:
            Text('Billing', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Carousel Slider for Advertisements
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: dark ? TColors.grey : TColors.lightGrey,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/placeholder_ad.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Advertisement $i',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: TSizes.spaceBtwSections),

              // Rounded Container with Billing Details
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    /// Pricing
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subtotal > 0
              ? () => orderController.processPrismaOrder()
              : () => TLoaders.warningSnackBar(
                  title: 'Empty Cart',
                  message: 'Add items in the cart in order to proceed.'),
          child: Obx(() => Text(
              'Checkout ₹${TPricingCalculator.calculateTotalPrice(subtotal, 'IND')}')),
        ),
      ),
    );
  }
}
