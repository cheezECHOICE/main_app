import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:food/features/shop/models/brand_model.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  // Variables
  final _brandEndpoint = '$dbLink/restaurant';
  final _productByBrandEndpoint = '$dbLink/products?brandid=';
  static final _brandByIdEndPoint = '$dbLink/restaurant?brandId=';

  final dio = Dio();

  Future<List<BrandModel>> getAllBrands() async {
    try {
      final request = await http.get(Uri.parse(_brandEndpoint));
      Map data = jsonDecode(request.body);
      List<BrandModel> brands = [];

      for (var item in data['data']) {
        brands.add(BrandModel.fromJson(item));
      }
      return brands;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get products for Brand
  Future<List<ProductModel>> getBrandProducts(String brandId) async {
    try {
      final request = await dio.get(
        '$_productByBrandEndpoint$brandId',
      );
      List<ProductModel> products = [];
      for (var item in request.data['data']) {
        products.add(ProductModel.fromJson(item));
      }
      return products;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get brands for Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    return [];
  }

  static Future<bool> isStoreClosed(int brandId) async {
  try {
    final response = await Dio().get('$_brandByIdEndPoint$brandId');
    
    // Check if the response contains the necessary data
    if (response.data != null && response.data['data'] != null) {
      // Return true if the store is closed
      return !(response.data['data']['isOpen'] ?? true);
    }
    
    // In case of unexpected data structure, assume store is closed
    return true; // or false depending on your application logic
  } catch (e) {
    // Optionally log the error for debugging
    print('Error fetching store status: $e');
    // Return false as a safe default on error
    return false;
  }
}

  static Future<Map<String, dynamic>> getParcelCharges(int brandId) async {
    try {
      final brand =
          (await Dio().get('$_brandByIdEndPoint$brandId')).data['data'];
      return {
        'parcelPerItem': brand['parcelPerItem'],
        'parcelCharge': brand['parcelCharge']
      };
    } catch (e) {
      print(e);
      return {};
    }
  }
}
