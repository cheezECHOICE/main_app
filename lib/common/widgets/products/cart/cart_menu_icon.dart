import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/location_selection.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/screens/wishlist/wishlist.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TWishlistCounterIcon extends StatelessWidget {
  const TWishlistCounterIcon({
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
            onPressed: () => Get.to(() =>  LocationSearchScreen()),
            icon: Icon(Icons.map_outlined, color: iconColor)),
        // Positioned(
        //   right: 0,
        //   child: SizedBox(
        //     width: 18,
        //     height: 18,
        //     decoration: BoxDecoration(
        //       color: TColors.white,
        //       borderRadius: BorderRadius.circular(100),
        //     ),
      ],
    );
  }
}
