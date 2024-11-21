import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
import 'package:cheezechoice/common/widgets/loaders/animation_loader.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final bool fromProfile;

  const CartScreen({Key? key, this.fromProfile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Obx(
        () {
          // Widget to display when the cart is empty
          final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops! Cart is Empty',
            animation: TImages.cartanimation,
            showAction: true,
            actionText: 'Let\'s fill it',
            onActionPressed: () {
              if (fromProfile) {
                Navigator.of(Get.context!).pop();
              }
              NavigationController.instance.selectedIndex.value = 1;
            },
          );

          if (controller.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            // Wrapping content in a SingleChildScrollView for scrollable behavior
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TCartItems(), // Cart items widget
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Obx(
        () => controller.cartItems.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const CheckOutScreen()),
                  child: Text('CheckOut Rs${controller.totalCartPrice.value}'),
                ),
              ),
      ),
    );
  }
}
