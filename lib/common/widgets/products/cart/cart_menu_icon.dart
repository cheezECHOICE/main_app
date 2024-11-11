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
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const FavouriteScreen()),
            icon: Icon(Iconsax.heart_add, color: iconColor)),
        const Positioned(
          right: 0,
          child: SizedBox(
            width: 18,
            height: 18,
            // decoration: BoxDecoration(
            //   color: TColors.white,
            //   borderRadius: BorderRadius.circular(100),
            // ),
            // child: Center(
            //   child: Obx(
            //     () => Text(
            //       controller.noOfCartItems.value.toString(),
            //     style: Theme.of(context).textTheme.labelLarge!.apply(
            //       color: counterTextColor ?? (dark ? TColors.black : TColors.white),
            //       fontSizeFactor: 0.8)),
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}
