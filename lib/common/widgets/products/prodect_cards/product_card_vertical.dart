import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/favourite_button.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/models/product_model.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/product_details_page.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../texts/product_price_text.dart';
import '../../texts/product_title_text.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showProductDetailBottomSheet(context, product);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: ShimmerImage(
                    imageUrl: product.thumbnail,
                    height: 130,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavouriteButton(
                    prodId: product.id,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(
                    title: product.title,
                    smallSize: true,
                  ),
                  const SizedBox(height: 4.0),
                  if (product.brand != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.brand!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TProductPriceText(
                          price: ' ${product.salePrice.round()}',
                        ),
                      ),
                      AddToCartButton(
                        product: product,
                        color: TColors.primary.withOpacity(0.8),
                        fontColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final ProductModel product;
  final Color? color;
  final Color? fontColor;
  final BorderRadius? borderRadius;

  const AddToCartButton({
    super.key,
    required this.product,
    this.color,
    this.fontColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());
    return Obx(() {
      return Container(
        child: cartController.getProductQuantityInCart(product.id) == 0
            ? GestureDetector(
                onTap: () => cartController.addOneProductToCart(product),
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? TColors.primary.withOpacity(0.8),
                    borderRadius: borderRadius ?? BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      color: fontColor ?? Colors.white,
                    ),
                  ),
                ),
              )
            : Container(
                width: 80,
                decoration: BoxDecoration(
                  color: color ?? TColors.primary.withOpacity(0.8),
                  borderRadius: borderRadius ?? BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          cartController.removeOneProductFromCart(product),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: fontColor ?? Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        cartController
                            .getProductQuantityInCart(product.id)
                            .toString(),
                        style: TextStyle(
                          color: fontColor ?? Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cartController.addOneProductToCart(product),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          '+',
                          style: TextStyle(color: fontColor ?? Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
