import 'package:flutter/material.dart';
import 'package:food/common/widgets/favourite_button.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/features/shop/screens/home/widgets/product_details_page.dart';
import 'package:food/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:food/features/shop/screens/store/widgets/splash_effect.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:get/get.dart';

class PopularProductCard extends StatelessWidget {
  final ProductModel product;

  const PopularProductCard(this.product, {super.key});

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
                    height: 100,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (product.brand != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
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
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${product.salePrice.round()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
            ? SplashEffect(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                onTap: () => cartController.addOneProductToCart(product),
                child: Material(
                  borderRadius: borderRadius ?? BorderRadius.circular(10),
                  color: color ?? TColors.primary.withOpacity(0.8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                    SplashEffect(
                      onTap: () =>
                          cartController.removeOneProductFromCart(product),
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
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
                    SplashEffect(
                      onTap: () => cartController.addOneProductToCart(product),
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text(
                            '+',
                            style: TextStyle(color: fontColor ?? Colors.white),
                          ),
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
