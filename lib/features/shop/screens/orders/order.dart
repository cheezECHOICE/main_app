import 'package:cheezechoice/features/shop/screens/orders/widgets/order_list.dart';
import 'package:cheezechoice/features/shop/screens/orders/widgets/order_list2.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'My Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order History Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Order History page
                    Get.to(() => OrderHistoryScreen());
                  },
                  child: Icon(Icons.history_rounded),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Orders List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Display recent orders
                  return TOrderListItems();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// New Order History Screen
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    // Load all orders for Order History page
    controller.getAllOrders();

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Order History',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return TOrderListItems2();
          }
        }),
      ),
    );
  }
}
