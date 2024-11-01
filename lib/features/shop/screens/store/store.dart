import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/brand_controller.dart';
import 'package:food/features/shop/screens/store/widgets/search_bar.dart';
import 'package:food/features/shop/screens/store/widgets/store_card.dart';
import 'package:food/utils/constants/sizes.dart';
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
  String filterOption = 'Food Street';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(filterOption,
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    filterOption = value;
                  });
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'In campus',
                    child: Text('In campus'),
                  ),
                  PopupMenuItem(
                    value: 'Deliveries',
                    child: Text('Deliveries'),
                  ),
                  PopupMenuItem(
                    value: 'Night canteen',
                    child: Text('Night canteen'),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MySearchBar(
                searchController: searchController,
                searchHint: 'Search for your favourite store',
                filterFunction: brandController.filterBrands,
              ),
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
                      return SingleChildScrollView(
                        child: const TStoreShimmer(),
                      );
                    }

                    if (brandController.brandsToShow.isEmpty) {
                      brandController.getAllBrands();
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
                            const SizedBox(height: 1.25 * TSizes.spaceBtwItems),
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
