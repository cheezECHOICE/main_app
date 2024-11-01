import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/screens/orders/widgets/order_list.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final List<String> filterOptions = [
      'Recent Orders',
      'Last 10 Days',
      'Last 30 Days'
    ];
    final List<int> filterDays = [5, 10, 30];

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
            // Filter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      controller.filterLabel.value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor, // Border color
                      width: 1, // Border width
                    ),
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                  child: IconButton(
                    icon: Icon(Iconsax.filter),
                    onPressed: () {
                      _showFilterBottomSheet(
                          context, controller, filterOptions, filterDays);
                    },
                    color: Theme.of(context).primaryColor, // Icon color
                  ),
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
                  return TOrderListItems();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, OrderController controller,
      List<String> filterOptions, List<int> filterDays) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Orders',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filterOptions[index]),
                    onTap: () {
                      controller.filterOrdersByDays(
                          filterDays[index], filterOptions[index]);
                      Navigator.pop(context); // Close bottom sheet on selection
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}