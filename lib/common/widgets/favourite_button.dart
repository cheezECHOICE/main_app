import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/product/favourite_controller.dart';
import 'package:get/get.dart';

class FavouriteButton extends StatelessWidget {
  final String prodId;
  final double size;

  const FavouriteButton({super.key, required this.prodId, this.size = 30});

  @override
  Widget build(BuildContext context) {
    FavouriteController favouriteController = Get.put(FavouriteController());
    return Obx(() {
      return GestureDetector(
        onTap: () => favouriteController.toggleFavouritesProduct(prodId),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            favouriteController.isFavourite(prodId)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.white,
            size: size / 2,
          ),
        ),
      );
    });
  }
}
