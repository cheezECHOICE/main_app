import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/home_controller.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/popular_product_card.dart';
import 'package:cheezechoice/utils/shimmers/popular_products_shimmer.dart';
import 'package:get/get.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Obx(() {
      if (homeController.isLoading.value) {
        return const TPopularProductsShimmer();
      }

      return GridView.builder(
        // itemCount: homeController.products.length,
        itemCount: 4,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjusted aspect ratio for better fit
        ),
        itemBuilder: (context, index) {
          final item = homeController.products[index];
          return PopularProductCard(item);
        },
      );
    });
  }
}
