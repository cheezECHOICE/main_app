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
    bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TLoaders.customToast(message: 'No Internet Connection');
      return; 
    }

    try {
      isLoading.value = true;
      final brands = await brandRepository.getAllBrands();
      brands.sort((a, b) {
        bool aIsOpen = a.isOpen ?? false;
        bool bIsOpen = b.isOpen ?? false;

        if (aIsOpen != bIsOpen) {
          return bIsOpen ? 1 : -1; 
        }
        return int.parse(a.id).compareTo(int.parse(b.id));
      });

      allBrands.assignAll(brands);
      brandsToShow.assignAll(brands);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false; 
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

//incampus filed
  Future<void> filterStoresByCampus(bool showInCampus) async {
    isLoading.value = true;
    final filteredBrands =
        allBrands.where((brand) => brand.inCampus == showInCampus).toList();
    brandsToShow.assignAll(filteredBrands);

    isLoading.value = false;
  }

//exclusive field
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
