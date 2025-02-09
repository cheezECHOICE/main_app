import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/screens/wishlist/wishlist.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TWishlistCounterIcon2 extends StatelessWidget {
  const TWishlistCounterIcon2({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
  });

  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    //Get and instance of the CartController
    final controller = Get.put(CartController());
    final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Icon(Icons.shopping_cart_sharp, color: iconColor)),
        // Positioned(
        //   right: 0,
        //   child: SizedBox(
        //     width: 18,
        //     height: 18,
        //     decoration: BoxDecoration(
        //       color: TColors.white,
        //       borderRadius: BorderRadius.circular(100),
        //     ),
        Positioned(
  right: 0,
  child: Container(
    width: 18,
    height: 16,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
    ),
            child: Center(
              child: Obx(
                () => Text(
                  controller.noOfCartItems.value.toString(),
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: counterTextColor ?? (dark ? TColors.black : TColors.white),
                  fontSizeFactor: 0.8)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
