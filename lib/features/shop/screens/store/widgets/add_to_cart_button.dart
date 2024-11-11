import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/models/product_model.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/splash_effect.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:get/get.dart';

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
    CartController cartController = CartController.instance;
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
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 34),
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
                width: 98,
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
                              vertical: 8, horizontal: 12),
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
                              vertical: 8, horizontal: 12),
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
