import 'package:cheezechoice/features/pickup/screens/handoff.dart';
import 'package:cheezechoice/address_selection.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/personalisation/screens/settings/settings.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/features/shop/screens/home/home.dart';
import 'package:cheezechoice/features/shop/screens/orders/order.dart';
import 'package:cheezechoice/features/shop/screens/store/store.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
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
                darkMode ? TColors.black : TColors.grey.withOpacity(0.1),
            indicatorColor: TColors.primary.withOpacity(0.2),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Hub'),
              //  NavigationDestination(icon: Icon(Iconsax.export), label: 'HandOff'),
              NavigationDestination(
                  icon: Icon(Iconsax.shop_add), label: 'Bistros'),
              NavigationDestination(
                  icon: Icon(Iconsax.bag_tick), label: 'Tray'),
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
      final brand = Get.put(BrandController());
      brand.resetBrands();
    }
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    // MapPage(),
    const StoreScreen(),
    // LocationSearchScreen(),
    const OrderScreen(),
    const SettingScreen(),
  ];
  // Method to navigate to "My Orders" in the Settings screen
  void goToMyOrders() {
    selectedIndex.value = 3; 
    Future.delayed(Duration(milliseconds: 100), () {
      Get.to(() => const OrderScreen());
    });
  }
  
}
