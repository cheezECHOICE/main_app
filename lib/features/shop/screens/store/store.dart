import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/brand_controller.dart';
import 'package:food/features/shop/screens/store/widgets/search_bar.dart';
import 'package:food/features/shop/screens/store/widgets/store_card.dart';
import 'package:food/utils/shimmers/store_shimmer.dart';
import 'package:get/get.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final brandController = Get.put(BrandController());
  final TextEditingController searchController = TextEditingController();
  String filterOption = 'All Restaurants';

  // Variable to track whether the user wants open stores only
  bool showOpenStoresOnly = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              filterOption,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Toggle between showing open and closed stores
                    showOpenStoresOnly = !showOpenStoresOnly;

                    // Filter brands based on the open/closed status
                    if (showOpenStoresOnly) {
                      brandController.brandsToShow.assignAll(
                        brandController.allBrands.where((store) {
                          // Filter only open stores
                          return store.isOpen == true;
                        }).toList(),
                      );
                    } else {
                      brandController.brandsToShow.assignAll(
                        brandController.allBrands.where((store) {
                          // Filter only closed stores
                          return store.isOpen == false || store.isOpen == null;
                        }).toList(),
                      );
                    }
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: showOpenStoresOnly
                      ? const Color(0xFF72D175) // Green for open stores
                      : const Color(0xFFEE7067), // Red for closed stores
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  showOpenStoresOnly ? 'Opened Stores' : 'Closed Stores',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MySearchBar(
                    searchController: searchController,
                    searchHint: 'Search for your favourite store',
                    filterFunction: brandController.filterBrands,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: EasyRefresh(
                  onRefresh: brandController.getAllBrands,
                  child: Obx(() {
                    if (brandController.isLoading.value) {
                      return const SingleChildScrollView(
                        child: TStoreShimmer(),
                      );
                    }

                    if (brandController.brandsToShow.isEmpty) {
                      return const Center(
                        child: Text('No stores found.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: brandController.brandsToShow.length,
                      itemBuilder: (context, index) {
                        final store = brandController.brandsToShow[index];
                        return Column(
                          children: [
                            StoreCard(store: store),
                            const SizedBox(height: 10),
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
      ),
    );
  }
}
