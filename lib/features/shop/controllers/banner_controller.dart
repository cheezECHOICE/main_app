import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/data/repositories/banners/banner_repository.dart';
import 'package:food/features/shop/models/banner_model.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  // Variables
  final carousalCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  // Update Page Navigational Dots
  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  //Fetch Banners
  Future<void> fetchBanners() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      //Assign Banners
      this.banners.assignAll(banners);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove Loader
      isLoading.value = false;
    }
  }
}
