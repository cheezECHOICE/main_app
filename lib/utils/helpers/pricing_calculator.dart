import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/screens/checkout/widgets/order_type.dart';

class TPricingCalculator {
  /// -- Calculate Price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {

    double taxRate = getTaxRateForLocation(productPrice, location);
    double taxAmount = productPrice * taxRate;

    int parcelCharge =
        (OrderController.instance.orderType == OrderType.takeout ||
                OrderController.instance.orderType == OrderType.choose)
            ? OrderController.instance.parcelCharge.value
            : 0;

    double totalPrice = productPrice + parcelCharge + taxRate.round();
    return totalPrice;
  }

  /// -- Calculate tax
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(productPrice,location);
    if (productPrice > 85) {
      double taxAmount = (productPrice * 0.0195).roundToDouble();
      return taxAmount.toStringAsFixed(2);
    } else {
      double taxAmount = 0.0;
      return taxAmount.toStringAsFixed(2);
    }
  }

  static double getTaxRateForLocation(double productPrice,String location) {
    // Lookup the tax rate for the given location from a tax rate database or API.
    // Return the appropriate tax rate.
    if (productPrice > 80) {
      return productPrice * 0.0195;
    } else {
      return 0.0;
    }// Example tax rate of 10%
  }

  /// -- Sum all cart values and return total amount
// static double calculateCartTotal(CartModel cart) {
//   return cart.items.map((e) => e.price).fold(0, (previousPrice, currentPrice) => previousPrice + (currentPrice ?? 0));
// }
}
