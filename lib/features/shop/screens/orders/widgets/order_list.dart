import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food/common/widgets/loaders/animation_loader.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/screens/orders/widgets/order_card.dart';
import 'package:food/navigation_menu.dart';
import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/cloud_helper_function.dart';
import 'package:get/get.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    
    return Obx(() {
      final orders = controller.orders;
      final emptyWidget = TAnimationLoaderWidget(
        text: 'Whoops! No Orders Yet!',
        animation: TImages.cartanimation,
        showAction: true,
        actionText: 'Let\'s Order Some',
        onActionPressed: () {
          Navigator.of(Get.context!).pop();
          NavigationController.instance.selectedIndex.value = 1;
        },
      );

      if (orders.isEmpty) return emptyWidget;

      final recentOrders = controller.getRecentOrders();

      return EasyRefresh(
        onRefresh: () async {
          await controller.fetchUserOrders();
        },
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: recentOrders.length,
          separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: OrderCard(recentOrders[index]),
            );
          },
        ),
      );
    });
  }
}
