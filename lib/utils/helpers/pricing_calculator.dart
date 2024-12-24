import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/order_type.dart';

class TPricingCalculator {
  /// -- Calculate Price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(productPrice, location);

    int parcelCharge =
        (OrderController.instance.orderType == OrderType.takeout ||
                OrderController.instance.orderType == OrderType.choose)
            ? OrderController.instance.parcelCharge.value
            : 0;

    double totalPrice = productPrice + parcelCharge + taxRate;
    return totalPrice;
  }



  /// -- Calculate Price based on tax and shipping
  static double TotalPrice(double productPrice, String location) {
    double CGST = getCGST(productPrice, location);
    double SGST = getSGST(productPrice, location);


    double totalPrice = productPrice;
    return double.parse(totalPrice.toStringAsFixed(2));
  }

  static double getTaxRateForLocation(double productPrice, String location) {
    return 2;
  }

  static double getDeliveryForLocation(double productPrice, String location) {
    // Lookup the tax rate for the given location from a tax rate database or API.
    // Return the appropriate tax rate.
    return 61;
  }

  static double getCGST(double productPrice, String location) {
    // Lookup the tax rate for the given location from a tax rate database or API.
    // Return the appropriate tax rate.
    return double.parse((calculateTotalPrice(productPrice, location) * 0.025).toStringAsFixed(2));
  }

  static double getSGST(double productPrice, String location) {
    // Lookup the tax rate for the given location from a tax rate database or API.
    // Return the appropriate tax rate.
    return double.parse((calculateTotalPrice(productPrice, location) * 0.025).toStringAsFixed(2));
  }

  static double finalTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(productPrice, location);
    double deliveryPrice = getDeliveryForLocation(productPrice, location);
    double CGST = getCGST(productPrice, location);
    double SGST = getSGST(productPrice, location);
    //double taxAmount = productPrice * taxRate;

    int parcelCharge =
        (OrderController.instance.orderType == OrderType.takeout ||
                OrderController.instance.orderType == OrderType.choose)
            ? OrderController.instance.parcelCharge.value
            : 0;

    double totalPrice = productPrice + parcelCharge + taxRate + deliveryPrice;
    return double.parse(totalPrice.toStringAsFixed(2));
  }


  /// -- Sum all cart values and return total amount
// static double calculateCartTotal(CartModel cart) {
//   return cart.items.map((e) => e.price).fold(0, (previousPrice, currentPrice) => previousPrice + (currentPrice ?? 0));
// }
}
