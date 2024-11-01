import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/global_search_controller.dart';
import 'package:food/features/shop/screens/store/widgets/dotted_divider.dart';
import 'package:food/features/shop/screens/store/widgets/product_card.dart';
import 'package:food/features/shop/screens/store/widgets/search_bar.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:food/utils/shimmers/brand_products_shimmer.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final GlobalSearchController globalSearchController =
        Get.put(GlobalSearchController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: THelperFunctions.screenWidth(),
          height: THelperFunctions.screenHeight(),
          child: ListView(
            children: [
              MySearchBar(
                searchController: searchController,
                searchHint: 'Search for your favourite dishes',
                filterFunction: globalSearchController.filterFood,
                autoFocus: true,
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (globalSearchController.isLoading.value) {
                  return const TBrandProductsShimmer();
                }
                return Column(
                  children: [
                    for (var item in globalSearchController.productsToShow)
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
