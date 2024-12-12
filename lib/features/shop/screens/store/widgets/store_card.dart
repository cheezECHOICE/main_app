import 'package:flutter/material.dart';
import 'package:cheezechoice/data/repositories/brands/brand_repository.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/features/shop/models/brand_model.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class StoreCard extends StatelessWidget {
  final BrandModel store;
  final double _borderRadius = 16;
  final String _fallbackimg =
      'https://st2.depositphotos.com/1419868/12430/i/950/depositphotos_124302476-stock-photo-unoccupied-generic-store-front.jpg';
  final OrderController orderController = Get.put(OrderController());

  StoreCard({super.key, required this.store});

  // Check if the store is currently open based on local time
  bool getStoreOpenStatus() {
    final now = DateTime.now();
    final openingTime =
        DateTime(now.year, now.month, now.day, 9, 0); // 11:00 AM
    final closingTime =
        DateTime(now.year, now.month, now.day, 20, 00); // 6:30 PM

    return now.isAfter(openingTime) && now.isBefore(closingTime);
  }

  void _showClosedMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restaurant is closed'),
          content: const Text(
              'The restaurant is closed. Please visit between 11:00 AM and 6:30 PM.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int brandId = int.parse(store.id);

    // Using FutureBuilder to get the store's open status asynchronously
    return FutureBuilder<bool>(
      future: BrandRepository.isStoreClosed(
          brandId), // Call to check if the store is closed
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200, // Height to keep the layout consistent
            child: Center(
                child: CircularProgressIndicator()), // Show loading indicator
          );
        }

        // If an error occurred during the fetch
        if (snapshot.hasError) {
          return Container(
            height: 200, // Height to keep the layout consistent
            child: Center(child: Text('Error loading store status')),
          );
        }

        // Determine if the store is open based on both local and server data
        final bool storeClosedFromApi =
            snapshot.data ?? false; // Store status from API
        final bool storeOpen = getStoreOpenStatus() && !storeClosedFromApi;

        return GestureDetector(
          onTap: () {
            if (storeOpen) {
              BrandController.instance.setCurrentBrand(store);
              Get.toNamed('/store/products', arguments: store.id);
            } else {
              _showClosedMessage(context);
            }
          },
          child: Container(
            width: THelperFunctions.screenWidth() * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: THelperFunctions.isDarkMode(context)
                  ? Colors.black54
                  : Colors.white,
              boxShadow: THelperFunctions.isDarkMode(context)
                  ? null
                  : const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 22,
                        offset: Offset(0, 0),
                      )
                    ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_borderRadius),
                    topRight: Radius.circular(_borderRadius),
                  ),
                  child: ColorFiltered(
                    colorFilter: storeOpen
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply)
                        : const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                    child: ShimmerImage(
                      height: 175,
                      width: THelperFunctions.screenWidth() * 0.85,
                      imageUrl:
                          store.image.isEmpty ? _fallbackimg : store.image,
                    ),
                  ),
                ),
                SizedBox(
                  width: THelperFunctions.screenWidth() * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '11:00am - 6:30pm',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: storeOpen
                                ? const Color.fromARGB(255, 114, 209, 117)
                                : const Color.fromARGB(255, 238, 112, 103),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            storeOpen ? 'OPEN' : 'CLOSED',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
