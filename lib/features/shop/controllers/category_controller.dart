import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/data/repositories/categories/category_repo.dart';
import 'package:food/features/shop/models/category_model.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryrepository = Get.put(CategoryRepository());
  late CategoryModel currentCategory;
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxList<ProductModel> productsToShow = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // Load Category data
  Future<void> fetchCategories() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      //Fetch categories from data Source (FireStore, API, etc.)
      final categories = await _categoryrepository.getAllCategories();

      //Update categories List
      allCategories.assignAll(categories);

      //Filter featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove Loader
      isLoading.value = false;
    }
  }

  // Get Category or sub Category Products
  void getCategoryProducts(String category) async {
    // Fetch limited 4 products against each subCategory;
    final products = await _categoryrepository.getProductsByCategory(category);
    productsToShow.assignAll(products);
    isLoading.value = false;
  }

  void setCategory(CategoryModel category) {
    isLoading.value = true;
    productsToShow.clear();
    currentCategory = category;
    getCategoryProducts(category.name);
  }
}
