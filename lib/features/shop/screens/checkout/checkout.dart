import 'package:flutter/material.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/common/widgets/products/cart/coupon_widget.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:food/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:food/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:food/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:food/features/shop/screens/checkout/widgets/order_type.dart';
// import 'package:food/features/shop/screens/checkout/widgets/otp_with_cart.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:food/utils/helpers/pricing_calculator.dart';
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_cart),
        //     onPressed: () {
        //       // Navigate to the new page
        //       Get.to(() => CartDetailsWithOtpScreen());
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///Items in cart
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              OrderTypeButton(),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Coupon Text
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Billing
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    ///Pricing
                    TBillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwSections),

                    ///Divider
                    Divider(),

                    ///Payment Method
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    ///Address
                    //TBillingAddressSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      ///Checkout Button
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