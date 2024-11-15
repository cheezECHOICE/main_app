import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/favourite_button.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/add_to_cart_button.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../models/product_model.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final ProductModel product;

  ProductDetailBottomSheet(this.product);

  @override
  Widget build(BuildContext context) {
    CartController cartController = CartController.instance;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    ShimmerImage(
                      imageUrl: product.thumbnail,
                      height: 200,
                      width: THelperFunctions.screenWidth() * 0.85,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavouriteButton(
                        prodId: product.id,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        product.nonveg == true
                            ? 'assets/logos/non-veg_icon.png'
                            : 'assets/logos/veg_icon.png',
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.star, color: Colors.orange),
                      Text('4.5'),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${product.price}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AddToCartButton(product: product),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'About ${product.title}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: THelperFunctions.screenWidth() * 0.85,
              decoration: BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                if (cartController.cartItems.length == 0) {
                  return ElevatedButton(
                    onPressed: () {
                      cartController.addOneProductToCart(product);
                      Get.to(() => CheckOutScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Instant Buy',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (cartController.cartItems.length == 1 &&
                    cartController.cartItems.first.productId == product.id) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Rs. ${cartController.cartItems.first.price * cartController.cartItems.first.quantity}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => Get.to(() => CheckOutScreen()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4),
                          child: Text(
                            'Place Order',
                            style: TextStyle(
                              color: THelperFunctions.isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            ),
                      ),
                    ],
                  );
                } else if (cartController.cartItems
                    .where((element) => element.brandId != product.brand!.id)
                    .isEmpty) {
                  return Container(
                    width: THelperFunctions.screenWidth() * 0.85,
                    height: 125,
                    decoration: BoxDecoration(
                      color: TColors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Cart already has items\nfrom another shop',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () => Get.to(() => CartScreen()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Go To Cart',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

void showProductDetailBottomSheet(BuildContext context, ProductModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: ProductDetailBottomSheet(product),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
