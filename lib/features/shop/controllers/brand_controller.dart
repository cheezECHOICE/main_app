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
      final openStores = allBrands
          .where((brand) =>
              brand.isOpen ==
              true) // Assuming `isOpen` is a field in BrandModel
          .toList();
      brandsToShow.assignAll(openStores);
    } else {
      brandsToShow.assignAll(allBrands);
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
  Future<void> filterStoresByCampus(bool showInCampus) async {
    isLoading.value = true;

    if (showInCampus) {
      // Filter for in-campus stores (brandId not in 1-2)
      final inCampusStores = allBrands
          .where((brand) =>
              !(int.parse(brand.id) >= 1 && int.parse(brand.id) <= 2))
          .toList();
      brandsToShow.assignAll(inCampusStores);
    } else {
      // Filter for off-campus stores (brandId in 1-2)
      final offCampusStores = allBrands
          .where(
              (brand) => int.parse(brand.id) >= 1 && int.parse(brand.id) <= 2)
          .toList();
      brandsToShow.assignAll(offCampusStores);
    }

    isLoading.value = false;
  }
}
