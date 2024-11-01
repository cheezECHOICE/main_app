import 'package:dio/dio.dart';
import 'package:food/features/shop/models/category_model.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/constants/api_constants.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();
  final _allCategoriesEndPoint = '$dbLink/categories';
  final _productsByCategoryEndPoint = '$dbLink/products?category=';

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      Dio dio = Dio();
      final response = await dio.get(_allCategoriesEndPoint);
      final List<CategoryModel> categories = [];
      for (var category in response.data['data']) {
        categories.add(CategoryModel.fromMap(category));
      }
      return categories;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      Dio dio = Dio();
      final response = await dio.get('$_productsByCategoryEndPoint$category');
      final List<ProductModel> categories = [];
      if (response.data['data'] == null) {
        return categories;
      }
      for (var category in response.data['data']) {
        categories.add(ProductModel.fromJson(category));
      }
      return categories;
    } catch (e) {
      print(e);
      throw 'Something went wrong. Please try again';
    }
  }
}
