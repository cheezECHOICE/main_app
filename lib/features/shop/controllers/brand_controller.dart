import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/data/repositories/brands/brand_repository.dart';
import 'package:food/features/authentication/controllers/signup/network_manager.dart';
import 'package:food/features/shop/models/brand_model.dart';
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

  Future<void> resetBrands() async {
    isLoading.value = true;
    brandsToShow.assignAll(allBrands);
    isLoading.value = false;
  }

  void setCurrentBrand(BrandModel brand) {
    currentBrand = brand;
  }
}
