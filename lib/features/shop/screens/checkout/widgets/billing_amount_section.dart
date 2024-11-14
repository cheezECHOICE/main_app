//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/order_type.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';
import 'package:get/get.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartcontroller = CartController.instance;
    final subTotal = cartcontroller.totalCartPrice.value;
    return Column(
      children: [
        ///SUbtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹$subTotal'.toString()),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        Column(
          children: [
            ///Tax fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CGST(%)Amt', style: Theme.of(context).textTheme.labelSmall),
            Text('₹${TPricingCalculator.getCGST(subTotal, 'IND')}',
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 3),
            //Delivery
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SGST(%)Amt', style: Theme.of(context).textTheme.labelSmall),
            Text('₹${TPricingCalculator.getSGST(subTotal, 'IND')}',
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
          ],
        ),


        Obx(() {
          if (OrderController.instance.orderType.value == OrderType.takeout ||
              OrderController.instance.orderType.value == OrderType.choose) {
            if (OrderController.instance.parcelChargeProcessing.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: const LinearProgressIndicator(),
              );
            }
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Parcel Charges',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('₹${OrderController.instance.parcelCharge.value}',
                        style: Theme.of(context).textTheme.labelLarge)
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
              ],
            );
          } else {
            return SizedBox();
          }
        }),

        const SizedBox(height: TSizes.spaceBtwItems / 2),

        ///Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.bodyLarge),
            Text('₹${TPricingCalculator.TotalPrice(subTotal, 'IND')}'),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems / 2),
        ///Divider
        Divider(),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
      
        Column(
          children: [
            ///Tax fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Platform Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${TPricingCalculator.getTaxRateForLocation(subTotal, 'IND')}',
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 3),
            //Delivery
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Delivery Charge', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${TPricingCalculator.getDeliveryForLocation(subTotal, 'IND')}',
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        ///Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.headlineMedium),
            Text('₹${TPricingCalculator.finalTotalPrice(subTotal, 'IND')}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
          ],
        ),
      ],
    );
  }
}
