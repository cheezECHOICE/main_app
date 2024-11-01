import 'package:food/data/products/product_repository.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final isLoading = false.obs;
  final _productRepository = Get.put(ProductRepository());
  RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    getPopularProducts();
    super.onInit();
  }

  Future<void> getPopularProducts() async {
    try {
      isLoading.value = true;
      final productsList = await _productRepository.getPopularProducts();
      products.assignAll(productsList);
    } catch (e) {
      throw 'Something went wrong. Please try again';
    } finally {
      isLoading.value = false;
    }
  }
}
