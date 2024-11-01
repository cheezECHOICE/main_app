import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/models/cart_item_model.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:get/get.dart';

class ModifyQuantityButton extends StatelessWidget {
  final CartItemModel cartItem;

  const ModifyQuantityButton({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    CartController cartController = CartController.instance;
    return Obx(() {
      return Container(
        width: 110,
        decoration: BoxDecoration(
          color: TColors.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => cartController.removeOneFromCart(cartItem),
              child: Container(
                color: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    '-',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                cartController
                    .getProductQuantityInCart(cartItem.productId)
                    .toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () => cartController.addOneToCart(cartItem),
              child: Container(
                color: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    '+',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
