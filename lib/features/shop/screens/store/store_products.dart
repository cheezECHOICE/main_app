import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/brand_products_controller.dart';
import 'package:food/features/shop/screens/cart/cart.dart';
import 'package:food/features/shop/screens/store/widgets/dotted_divider.dart';
import 'package:food/features/shop/screens/store/widgets/filter_button.dart';
import 'package:food/features/shop/screens/store/widgets/product_card.dart';
import 'package:food/features/shop/screens/store/widgets/search_bar.dart';
import 'package:food/features/shop/screens/store/widgets/store_info_cards.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/shimmers/brand_products_shimmer.dart';
import 'package:get/get.dart';

class StoreProductsScreen extends StatelessWidget {
  final bool fromProfile;
  const StoreProductsScreen({Key? key, this.fromProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BrandProductsController bpc = Get.put(BrandProductsController());
    final TextEditingController searchController = TextEditingController();
    bpc.getBrandProducts(Get.arguments.toString());

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Column(
          children: [
            Center(
              child: AppBar(
                leading: BackButton(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  bpc.brand.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: isDarkMode ? Colors.white : Colors.black,
                    onPressed: () => Get.to(() => const CartScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1.5 * TSizes.spaceBtwItems),
            MySearchBar(
              searchController: searchController,
              searchHint: 'Search for your favourite items',
              filterFunction: bpc.filterFood,
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Obx(() {
              if (bpc.isLoading.value) {
                return const SizedBox();
              }

              return Row(
                children: [
                  const SizedBox(width: TSizes.spaceBtwItems),
                  const Text(
                    'Filter by',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems * 2),
                  FilterButton(
                    filterFunction: bpc.filterVeg,
                    isEnabled: bpc.filterVegEnabled,
                    mainColor: const Color(0xFF4CAF50),
                    label: 'Veg',
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  FilterButton(
                    filterFunction: bpc.filterNonVeg,
                    isEnabled: bpc.filterNonVegEnabled,
                    mainColor: const Color(0xFFE57373),
                    label: 'Non-Veg',
                  ),
                ],
              );
            }),
            const Divider(thickness: 1, height: 15), // Adjusted height
            Expanded(
              child: EasyRefresh(
                onRefresh: () => bpc.getBrandProducts(bpc.brand.id),
                child: Obx(() {
                  if (bpc.isLoading.value) {
                    return SingleChildScrollView(
                        child: const TBrandProductsShimmer());
                  }

                  return ListView.builder(
                    itemCount: bpc.productsToShow.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: const [
                            StoreInfoCards(),
                            SizedBox(height: 18),
                            Divider(thickness: 1, height: 15),
                          ],
                        );
                      }

                      final product = bpc.productsToShow[index - 1];
                      return Column(
                        children: [
                          ProductCard(product: product),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            child: DottedDivider(),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
