import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class AddToCartRoundButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartRoundButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    CartController cartController = CartController.instance;
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => cartController.removeOneProductFromCart(product),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(212, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  '-',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(212, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Text(
                  cartController
                      .getProductQuantityInCart(product.id)
                      .toString(),
                  textAlign: TextAlign.center),
            ),
          ),
          GestureDetector(
            onTap: () => cartController.addOneProductToCart(product),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(212, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
