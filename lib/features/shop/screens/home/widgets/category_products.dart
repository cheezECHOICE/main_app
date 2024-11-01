import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/features/shop/controllers/category_controller.dart';
import 'package:food/features/shop/screens/store/widgets/dotted_divider.dart';
import 'package:food/features/shop/screens/store/widgets/product_card.dart';
import 'package:food/features/shop/screens/store/widgets/search_bar.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/shimmers/brand_products_shimmer.dart';
import 'package:get/get.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = CategoryController.instance;
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          categoryController.currentCategory.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: ListView(
          children: [
            MySearchBar(
              searchController: searchController,
              searchHint: 'Search for your favourite items',
              filterFunction: () {},
            ),
            const SizedBox(height: 2 * TSizes.defaultSpace),
            Obx(() {
              if (categoryController.isLoading.value) {
                return const TBrandProductsShimmer();
              }
              return Column(
                children: [
                  for (var item in categoryController.productsToShow)
                    Column(
                      children: [
                        ProductCard(product: item),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: DottedDivider(),
                        ),
                      ],
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
