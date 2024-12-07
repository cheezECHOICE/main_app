import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/brand_products_controller.dart';
import 'package:cheezechoice/features/shop/screens/cart/cart.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/dotted_divider.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/filter_button.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/product_card.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/search_bar.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/store_info_cards.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/shimmers/brand_products_shimmer.dart';
import 'package:get/get.dart';

class StoreProductsScreen extends StatelessWidget {
  final bool fromProfile;
  const StoreProductsScreen({Key? key, this.fromProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final BrandProductsController bpc = Get.put(BrandProductsController());
    final CartController cartController = Get.put(CartController());
    final TextEditingController searchController = TextEditingController();
    final String brandId = Get.arguments.toString();
    bpc.getBrandProducts(Get.arguments.toString());

    return Scaffold(
      body: EasyRefresh(
        header: ClassicHeader(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold), // Set text color to black
          iconTheme:
              IconThemeData(color: Colors.black), // Set icon color to black
        ),
        footer: ClassicFooter(
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold), // Set text color to black
          iconTheme:
              IconThemeData(color: Colors.black), // Set icon color to black
        ),
        onRefresh: () async {
          await bpc.getBrandProducts(bpc.brand.id);
        },
        child: CustomScrollView(
          slivers: [
            // SliverAppBar with background image and solid background color
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              backgroundColor: isDarkMode
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.9),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: isDarkMode ? TColors.white : TColors.black,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
                    title: Opacity(
                      opacity: top <= 120 ? 1 : 0,
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
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    // child: IconButton(
                    //   icon: const Icon(Icons.shopping_cart),
                    //   color: isDarkMode ? Colors.white : Colors.black,
                    //   onPressed: () => Get.to(() => const CartScreen()),
                    // ),
                  ),
                ),
              ],
            ),

            // Store Info Cards section
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    StoreInfoCards(
                      brandId: brandId,
                    ),
                  ],
                ),
              ),
            ),

            // Search bar and filters
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
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
                      // Check if any filter is active
                      bool isFilterActive = bpc.filterVegEnabled.value ||
                          bpc.filterNonVegEnabled.value;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isFilterActive
                                    ? Colors.red
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Filter by',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isFilterActive
                                    ? Colors.red
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors
                                            .black), // Text color dynamically
                              ),
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

            // Product List with SliverList
            Obx(() {
              if (bpc.isLoading.value) {
                return SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: const TBrandProductsShimmer(),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  childCount: bpc.productsToShow.length,
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: TColors.primary,
            onPressed: () => Get.to(() => const CartScreen()),
            child: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
          // Notification Badge
          Positioned(
            right: 0,
            top: 0,
            child: Obx(() {
              if (cartController.noOfCartItems.value > 0) {
                return Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${cartController.noOfCartItems.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }
}
