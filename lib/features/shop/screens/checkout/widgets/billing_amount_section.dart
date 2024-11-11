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

        ///Shipping fee
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
        //     Text(
        //         '₹${TPricingCalculator.calculateShippingCost(subTotal, 'IND')}',
        //         style: Theme.of(context).textTheme.labelLarge)
        //   ],
        // ),
        // const SizedBox(height: TSizes.spaceBtwItems / 2),

        ///Tax fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Platform Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('₹${TPricingCalculator.calculateTax(subTotal, 'IND')}',
                style: Theme.of(context).textTheme.labelLarge)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

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

        ///Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Obx(
              () {
                if (OrderController.instance.parcelChargeProcessing.value) {
                  return const LinearProgressIndicator();
                }
                return Text(
                  '₹${TPricingCalculator.calculateTotalPrice(subTotal, 'IND')}',
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
