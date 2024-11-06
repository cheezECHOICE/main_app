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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final BrandProductsController bpc = Get.put(BrandProductsController());
    final TextEditingController searchController = TextEditingController();
    bpc.getBrandProducts(Get.arguments.toString());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with background image and solid background color
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: isDarkMode
                ? Colors.black.withOpacity(0.7)
                : Colors.white.withOpacity(0.9),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: isDarkMode ? Colors.white : Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                      left: 72, bottom: 16), // Adjusted padding for title
                  title: Opacity(
                    opacity: top <= 120 ? 1 : 0, // Fade in/out based on scroll
                    child: Text(
                      bpc.brand.name,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Image.network(
                    bpc.brand.image.isEmpty
                        ? 'https://st2.depositphotos.com/1419868/12430/i/950/depositphotos_124302476-stock-photo-unoccupied-generic-store-front.jpg'
                        : bpc.brand.image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: isDarkMode ? Colors.white : Colors.black,
                onPressed: () => Get.to(() => const CartScreen()),
              ),
            ],
          ),

          // Store Info Cards section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: const [
                  StoreInfoCards(),
                ],
              ),
            ),
          ),

          // Search bar and filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Search bar below the StoreInfoCards
                  MySearchBar(
                    searchController: searchController,
                    searchHint: 'Search for your favourite items',
                    filterFunction: bpc.filterFood,
                  ),
                  const SizedBox(height: TSizes.defaultSpace),

                  // Filter buttons
                  Obx(() {
                    if (bpc.isLoading.value) {
                      return const SizedBox();
                    }

                    return Row(
                      children: [
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
                  const Divider(thickness: 1, height: 15),
                ],
              ),
            ),
          ),

          // Product List
          SliverFillRemaining(
            child: EasyRefresh(
              onRefresh: () => bpc.getBrandProducts(bpc.brand.id),
              child: Obx(() {
                if (bpc.isLoading.value) {
                  return SingleChildScrollView(
                      child: const TBrandProductsShimmer());
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bpc.productsToShow.length,
                  itemBuilder: (context, index) {
                    final product = bpc.productsToShow[index];
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
    );
  }
}
