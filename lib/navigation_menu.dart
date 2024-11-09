import 'package:flutter/material.dart';
import 'package:food/features/personalisation/screens/settings/settings.dart';
import 'package:food/features/shop/controllers/brand_controller.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/screens/cart/cart.dart';
import 'package:food/features/shop/screens/home/home.dart';
import 'package:food/features/shop/screens/orders/order.dart';
import 'package:food/features/shop/screens/store/store.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    Get.put(CartController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Obx(() {
      return PopScope(
        canPop: controller.selectedIndex.value == 0,
        onPopInvoked: (didPop) {
          _resetStores();
          controller.selectedIndex.value = 0;
        },
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              _resetStores();
              controller.selectedIndex.value = index;
            },
            backgroundColor:
                darkMode ? TColors.black : TColors.white.withOpacity(0.1),
            indicatorColor: TColors.primary.withOpacity(0.2),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Iconsax.shop_add), label: 'Store'),
              NavigationDestination(
                  icon: Icon(Iconsax.shopping_cart), label: 'Cart'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
            ],
          ),
          body: Obx(() => controller.screens[controller.selectedIndex.value]),
        ),
      );
    });
  }

  void _resetStores() {
    if (NavigationController.instance.selectedIndex.value == 1) {
      BrandController.instance.resetBrands();
    }
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const CartScreen(),
    const SettingScreen(),
  ];
  // Method to navigate to "My Orders" in the Settings screen
  void goToMyOrders() {
    selectedIndex.value = 3; // Index for 'Profile' Tab
    Future.delayed(Duration(milliseconds: 100), () {
      Get.to(() => const OrderScreen());
    });
  }
}
