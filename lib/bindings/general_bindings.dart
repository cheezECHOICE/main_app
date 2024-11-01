import 'package:food/features/authentication/controllers/signup/network_manager.dart';
import 'package:food/features/personalisation/controllers/address_controller.dart';
import 'package:food/features/shop/controllers/product/checkout_controller.dart';
import 'package:food/features/shop/controllers/product/variation_controller.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(AddressController());
    Get.put(CheckoutController());
  }
}
