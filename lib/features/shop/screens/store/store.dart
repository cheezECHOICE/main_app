import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/search_bar.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/store_card.dart';
import 'package:cheezechoice/utils/shimmers/store_shimmer.dart';
import 'package:get/get.dart';
import 'package:cheezechoice/common/styles/TRoundedContainer.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final brandController = Get.put(BrandController());
  final TextEditingController searchController = TextEditingController();

  // Default dropdown value
  String filterOption = 'Show All';

  // Available options for the dropdown
  final List<String> filterOptions = [
    'Show All',
    'Opened Stores',
    'Closed Stores'
  ];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'All Restaurants',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.dark : TColors.white,
                padding: const EdgeInsets.only(right: 4, left: 4),
                child: DropdownButton<String>(
                  value: filterOption,
                  icon: const Icon(Icons.arrow_drop_down),
                  underline: SizedBox.shrink(),
                  borderRadius:
                      BorderRadius.circular(2), // Narrower border radius
                  dropdownColor: dark ? TColors.dark : TColors.white,
                  items: filterOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(
                          color: dark ? TColors.white : TColors.dark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        filterOption = newValue;
                        // Update the list based on selection
                        if (filterOption == 'Opened Stores') {
                          brandController.brandsToShow.assignAll(
                            brandController.allBrands
                                .where((store) => store.isOpen == true)
                                .toList(),
                          );
                        } else if (filterOption == 'Closed Stores') {
                          brandController.brandsToShow.assignAll(
                            brandController.allBrands
                                .where((store) =>
                                    store.isOpen == false ||
                                    store.isOpen == null)
                                .toList(),
                          );
                        } else {
                          // Show All Stores
                          brandController.brandsToShow
                              .assignAll(brandController.allBrands);
                        }
                      });
                    }
                  },
                  style: TextStyle(
                    color: dark ? TColors.white : TColors.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  iconSize: 20,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    left: 8,
                    right: 8,
                  ),
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
