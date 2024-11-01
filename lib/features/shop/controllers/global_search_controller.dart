import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/data/products/product_repository.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class GlobalSearchController extends GetxController {
  static GlobalSearchController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<ProductModel> productsToShow = <ProductModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final ProductRepository productRepository = Get.put(ProductRepository());

  @override
  void onInit() {
    getAllProducts();
    super.onInit();
  }

  Future<void> getAllProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getAllProducts();
      allProducts.assignAll(products);
      productsToShow.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      //Stop Loading
      isLoading.value = false;
    }
  }

  void filterFood(String query) {
    if (query.isNotEmpty) {
      final List<ProductModel> searchList = [];
      for (var product in allProducts) {
        if (product.title.toLowerCase().contains(query.toLowerCase())) {
          searchList.add(product);
        }
      }
      productsToShow.assignAll(searchList);
      return;
    }
    productsToShow.assignAll(allProducts);
  }
}
