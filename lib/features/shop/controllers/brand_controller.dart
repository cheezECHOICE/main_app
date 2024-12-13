import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
import 'package:cheezechoice/data/repositories/brands/brand_repository.dart';
import 'package:cheezechoice/features/authentication/controllers/signup/network_manager.dart';
import 'package:cheezechoice/features/shop/models/brand_model.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  late BrandModel currentBrand;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> brandsToShow = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());
  final RxBool storeStatus = true.obs;

  @override
  void onInit() {
    getAllBrands();
    super.onInit();
  }

  // Load Brands
  Future<void> getAllBrands() async {
    // Check internet connection before making API call
    bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TLoaders.customToast(message: 'No Internet Connection');
      return; // Exit early if there's no internet connection
    }

    try {
      isLoading.value = true;
      final brands = await brandRepository.getAllBrands();

      // Sort by isOpen first (open stores first), then by ID in ascending order
      brands.sort((a, b) {
        // Ensure `isOpen` is treated as false when null
        bool aIsOpen = a.isOpen ?? false;
        bool bIsOpen = b.isOpen ?? false;

        // Sort by isOpen (open stores first)
        if (aIsOpen != bIsOpen) {
          return bIsOpen ? 1 : -1; // Open stores come first
        }

        // If isOpen is the same, sort by ID in ascending order
        return int.parse(a.id).compareTo(int.parse(b.id));
      });

      allBrands.assignAll(brands);
      brandsToShow.assignAll(brands);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Filter Brands
  Future<void> filterBrands(String brandName) async {
    if (brandName.isEmpty) {
      isLoading.value = true;
      brandsToShow.assignAll(allBrands);
      isLoading.value = false;
    } else {
      final filteredBrands = allBrands
          .where((brand) => brand.name.toLowerCase().contains(brandName))
          .toList();
      brandsToShow.assignAll(filteredBrands);
    }
  }

  // is closed or open
  Future<void> filterStoresByStatus(bool showOnlyOpen) async {
    isLoading.value = true;

    // Filter based on store status
    if (showOnlyOpen) {
      final openStores =
          allBrands.where((brand) => brand.isOpen == true).toList();
      brandsToShow.assignAll(openStores);
    } else {
      final closedStores = allBrands
          .where((brand) => brand.isOpen == false) // Closed stores filter
          .toList();
      brandsToShow.assignAll(closedStores);
    }

    isLoading.value = false;
  }

  Future<void> resetBrands() async {
    isLoading.value = true;
    brandsToShow.assignAll(allBrands);
    isLoading.value = false;
  }

  void setCurrentBrand(BrandModel brand) {
    currentBrand = brand;
  }

  // Delivery Time
  Future<String?> getDeliveryTime(String brandId) async {
    try {
      final brand = await brandRepository.getBrandById(brandId);
      return brand?.deliveryTime; // Return deliveryTime
    } catch (e) {
      print('Error fetching delivery time: $e');
      return null;
    }
  }

  // filter function
  // Future<void> filterStoresByCampus(bool showInCampus) async {
  //   isLoading.value = true;

  //   if (showInCampus) {
  //     // Filter for in-campus stores (brandId is 4)
  //     final inCampusStores =
  //         allBrands.where((brand) => int.parse(brand.id) == 1).toList();
  //     brandsToShow.assignAll(inCampusStores);
  //   } else {
  //     // Filter for off-campus stores (brandId is 1, 2, or 3)
  //     final offCampusStores =
  //         allBrands.where((brand) => int.parse(brand.id) > 1).toList();
  //     brandsToShow.assignAll(offCampusStores);
  //   }
  //   isLoading.value = false;
  // }
  Future<void> filterStoresByCampus(bool showInCampus) async {
    isLoading.value = true;

    // Filter based on the `inCampus` field
    final filteredBrands =
        allBrands.where((brand) => brand.inCampus == showInCampus).toList();
    brandsToShow.assignAll(filteredBrands);

    isLoading.value = false;
  }

  Future<void> filterStoresByExclusive(bool showExclusive) async {
    isLoading.value = true;

    if (showExclusive) {
      final exclusiveStores =
          allBrands.where((brand) => brand.exclusive == true).toList();
      brandsToShow.assignAll(exclusiveStores);
    } else {
      brandsToShow.assignAll(allBrands); // Reset filter
    }

    isLoading.value = false;
  }

  // Fetch and update isExclusive status for a specific brand
  Future<void> updateIsExclusiveStatus(String brandId) async {
    try {
      final isExclusive = await brandRepository.fetchIsExclusive(brandId);
      final brand = allBrands.firstWhere((b) => b.id == brandId);
      brand.exclusive = isExclusive; // Update the local model
      brandsToShow.refresh(); // Refresh observable list
    } catch (e) {
      print('Error updating exclusive status: $e');
    }
  }
}
