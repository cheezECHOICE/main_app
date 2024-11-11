import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/category_controller.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/category_card.dart';
import 'package:cheezechoice/utils/shimmers/category_shimmer.dart';
import 'package:get/get.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if (categoryController.isLoading.value) return const TCategoryShimmer();

      if (categoryController.allCategories.isEmpty) {
        return Center(
          child: Text(
            'No Data Found',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.white),
          ),
        );
      }

      return SizedBox(
        height: categoryController.allCategories.length > 6 ? 200 : 100,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: categoryController.allCategories.length > 6 ? 2 : 1,
            childAspectRatio: 1,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categoryController.allCategories.length,
          itemBuilder: (_, index) {
            return CategoryCard(
              categoryModel: categoryController.allCategories[index],
            );
          },
        ),
      );
    });
  }
}
