import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/search_bar.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/store_card.dart';
import 'package:cheezechoice/utils/shimmers/store_shimmer.dart';
import 'package:get/get.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/animated_filter_button.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final brandController = Get.put(BrandController());
  final TextEditingController searchController = TextEditingController();

  // Track selected filter, null means no filter (default: show all)
  String? selectedFilter;

  void setFilter(String? filter) {
    setState(() {
      selectedFilter = filter;
    });

    // Apply filtering logic
    switch (filter) {
      case 'Opened Stores':
        brandController.filterStoresByStatus(true);
        break;
      case 'Closed Stores':
        brandController.filterStoresByStatus(false);
        break;
      case 'In-Campus':
        brandController.filterStoresByCampus(true);
        break;
      case 'Off-Campus':
        brandController.filterStoresByCampus(false);
        break;
      default:
        brandController.resetBrands();
    }
  }

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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MySearchBar(
                    searchController: searchController,
                    searchHint: 'Search for your favourite store',
                    filterFunction: brandController.filterBrands,
                  ),
                ),
                const SizedBox(height: 15.0),
                Obx(() {
                  if (brandController.isLoading.value) {
                    return const SizedBox();
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedFilter == null
                                  ? (dark ? Colors.white : Colors.black)
                                  : Colors
                                      .red, // Border color changes dynamically
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Filter by',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: selectedFilter == null
                                  ? (dark ? Colors.white : Colors.black)
                                  : Colors
                                      .red, // Text color changes dynamically
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems * 1.5),
                        AnimatedFilterButton(
                          label: 'In-Campus',
                          isSelected: selectedFilter == 'In-Campus',
                          onPressed: () {
                            setFilter(selectedFilter == 'In-Campus'
                                ? null
                                : 'In-Campus');
                            if (selectedFilter == 'In-Campus') {
                              brandController.filterStoresByCampus(true);
                            } else {
                              brandController.resetBrands();
                            }
                          },
                        ),
                        const SizedBox(width: 8.0),
                        AnimatedFilterButton(
                          label: 'Off-Campus',
                          isSelected: selectedFilter == 'Off-Campus',
                          onPressed: () {
                            setFilter(selectedFilter == 'Off-Campus'
                                ? null
                                : 'Off-Campus');
                            if (selectedFilter == 'Off-Campus') {
                              brandController.filterStoresByCampus(false);
                            } else {
                              brandController.resetBrands();
                            }
                          },
                        ),
                        const SizedBox(width: 8.0),
                        AnimatedFilterButton(
                          label: 'Exclusive',
                          isSelected: selectedFilter == 'Exclusive',
                          onPressed: () {
                            setFilter(selectedFilter == 'Exclusive'
                                ? null
                                : 'Exclusive');
                            if (selectedFilter == 'Exclusive') {
                              brandController.filterStoresByExclusive(true);
                            } else {
                              brandController.resetBrands();
                            }
                          },
                        ),

                        const SizedBox(width: 8.0),
                        AnimatedFilterButton(
                          label: 'Opened Stores',
                          isSelected: selectedFilter == 'Opened Stores',
                          onPressed: () {
                            setFilter(
                              selectedFilter == 'Opened Stores'
                                  ? null
                                  : 'Opened Stores',
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        AnimatedFilterButton(
                          label: 'Closed Stores',
                          isSelected: selectedFilter == 'Closed Stores',
                          onPressed: () {
                            setFilter(
                              selectedFilter == 'Closed Stores'
                                  ? null
                                  : 'Closed Stores',
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        AnimatedFilterButton(
                          label: 'Popular',
                          isSelected: selectedFilter == 'Popular',
                          onPressed: () {
                            setFilter(
                              selectedFilter == 'Popular' ? null : 'Popular',
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        // AnimatedFilterButton(
                        //   label: 'Top Rated',
                        //   isSelected: selectedFilter == 'Top Rated',
                        //   onPressed: () {
                        //     setFilter(
                        //       selectedFilter == 'Top Rated'
                        //           ? null
                        //           : 'Top Rated',
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                // This ensures the ListView gets bounded height
                child: EasyRefresh(
                  onRefresh: () async {
                    setState(() {
                      selectedFilter = null; // Clear the filter on refresh
                    });
                    await brandController
                        .getAllBrands(); // Fetch all brands again
                  },
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
