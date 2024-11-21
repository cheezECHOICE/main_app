import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/products/cart/cart_item.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/widgets/modify_quantity_button.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/texts/product_price_text.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(
      () => Column(
        children: List.generate(
          cartController.cartItems.length,
          (index) {
            final item = cartController.cartItems[index];
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: TCartItem(cartItem: item)),
                    if (!showAddRemoveButtons)
                      Material(
                        borderRadius: BorderRadius.circular(10),
                        color: TColors.primary.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 34),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                if (showAddRemoveButtons)
                  const SizedBox(height: TSizes.spaceBtwItems),
                if (showAddRemoveButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 70),
                          ModifyQuantityButton(cartItem: item),
                        ],
                      ),
                      TProductPriceText(
                          price:
                              (item.price * item.quantity).toStringAsFixed(1)),
                    ],
                  ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            );
          },
        ),
      ),
    );
  }
}
