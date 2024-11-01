import 'package:flutter/material.dart';
import 'package:food/data/repositories/brands/brand_repository.dart';
import 'package:food/features/shop/controllers/brand_controller.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/models/brand_model.dart';
import 'package:food/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StoreCard extends StatelessWidget {
  final BrandModel store;
  final double _borderRadius = 16;
  final String _fallbackimg =
      'https://st2.depositphotos.com/1419868/12430/i/950/depositphotos_124302476-stock-photo-unoccupied-generic-store-front.jpg';
  final OrderController orderController = Get.put(OrderController());

 StoreCard({super.key, required this.store});

  bool getStoreOpenStatus() {
    final now = DateTime.now();
    final openingTime = DateTime(now.year, now.month, now.day, 1, 0); // 9:00 AM
    final closingTime = DateTime(now.year, now.month, now.day, 24, 0); // 6:00 PM

    final isOpen = now.isAfter(openingTime) && now.isBefore(closingTime);

    // Update the store status in the database
    //orderController.updateStoreStatus(store.id, isOpen);

    return isOpen;
  }
  

  void _showClosedMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restaurant is closed'),
          content: const Text(
              'The restaurant is closed. Please visit between 8:00 AM and 7:30 PM.'),
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
    final bool isOpen = getStoreOpenStatus();
    // final Future<bool> status = BrandRepository.isStoreClosed(brandId);
    

    return GestureDetector(
      onTap: () {
        if (isOpen) {
          //if(BrandRepository.isStoreClosed(brandId)==false){
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
                colorFilter: isOpen
                    ? const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply)
                    : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                child: ShimmerImage(
                  height: 175,
                  width: THelperFunctions.screenWidth() * 0.85,
                  imageUrl: store.image == '' ? _fallbackimg : store.image,
                ),
              ),
            ),
            SizedBox(
              width: THelperFunctions.screenWidth() * 0.85,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
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
                          '9:00am - 6:00pm',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? const Color.fromARGB(255, 114, 209, 117)
                            : const Color.fromARGB(255, 238, 112, 103),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isOpen  ? 'OPEN' : 'CLOSED',
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
  }
}
