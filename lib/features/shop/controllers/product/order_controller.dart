import 'package:cheezechoice/check.dart';
import 'package:cheezechoice/features/shop/controllers/brand_controller.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/select_addresses.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
import 'package:cheezechoice/common/widgets/success_screen/success_screen.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/data/repositories/brands/brand_repository.dart';
import 'package:cheezechoice/data/repositories/order/order_repo.dart';
import 'package:cheezechoice/features/personalisation/controllers/address_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/controllers/product/checkout_controller.dart';
import 'package:cheezechoice/features/shop/models/order_model.dart';
import 'package:cheezechoice/features/shop/models/payment_method_model.dart';
import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:cheezechoice/features/shop/screens/checkout/widgets/order_type.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/utils/constants/enums.dart';
import 'package:cheezechoice/utils/constants/image_strings.dart';
import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';
import 'package:cheezechoice/utils/popups/fullScreenLoader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<OrderType> orderType = OrderType.dineIn.obs;
  final RxBool parcelChargeProcessing = false.obs;
  final RxInt parcelCharge = 0.obs;
  final RxInt filterDays = 0.obs;
  final RxString filterLabel = 'Recent Orders'.obs;
  var isLoading = false.obs;
  String? selectedAddress;

  final authRepo = Get.put(AuthenticationRepository());
  final FirebaseMessaging firebaseMessaging =
      FirebaseMessaging.instance; 

  void setSelectedAddress(String address) {
    selectedAddress = address;
  }




  // order status for OTP
  List<OrderModel> getOrdersByStatus(String status) {
    return orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }


  Future<void> calculateParcelCharges() async {
    parcelChargeProcessing.value = true;
    final cart = CartController.instance;
    parcelCharge.value = 0;
    try {
      Map<String, dynamic> parcelChargeData =
          await BrandRepository.getParcelCharges(cart.cartItems.first.brandId);

      if (parcelChargeData['parcelPerItem'] ?? true) {
        cart.cartItems.forEach((element) {
          if (element.takeoutQuantity > 0)
            parcelCharge.value +=
                ((parcelChargeData['parcelCharge'] as num).toInt() *
                    element.takeoutQuantity);
        });
      } else {
        parcelCharge.value = (parcelChargeData['parcelCharge'] as num).toInt();
      }
    } on Exception catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }

    parcelChargeProcessing.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserOrders();
    handleFcmTokenRefresh();
  }

  Future<void> fetchUserOrders() async {
    isLoading.value = true;
    try {
      orders.value = await orderRepository.fetchUserOrdersPrisma();
      getRecentOrders();
    } finally {
      isLoading.value = false;
    }
  }

  

  // // timer clause checkss.
  Future<bool> validateCheckoutClauses() async {
    final authController = AuthController.instance;

String token = authController.authToken.value;
String userId = authController.userId.value;

print('Stored Token: $token');
print('Stored User ID: $userId');
    // final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null || userId.isEmpty) {
      TLoaders.warningSnackBar(
          title: 'Authentication Required',
          message: 'Please log in to continue.');
      return false;
    }

    // Check if an address is selected
    if (selectedAddress == null) {
      TLoaders.warningSnackBar(
          title: 'Address Required',
          message: 'Please select a delivery address.');
      return false;
    }

    // Check if the cart value meets the minimum requirement
    if (cartController.totalCartPrice.value < 1) {
      TLoaders.warningSnackBar(
        title: 'Minimum Order Value',
        message: 'Your SubTotal value must be at least ₹180 to proceed.',
      );
      return false;
    }

    // Check if the store is open
    if (await BrandRepository.isStoreClosed(
        cartController.cartItems.first.brandId)) {
      TLoaders.warningSnackBar(
          title: 'Store Closed',
          message: 'Store is closed. Please try again later.');
      return false;
    }

    // All checks passed
    return true;
  }

  // Function to retrieve recent orders
  List<OrderModel> getRecentOrders() {
    final DateTime now = DateTime.now();
    final DateTime startOfToday =
        DateTime(now.year, now.month, now.day); // Start of the day
    return orders
        .where((order) =>
            order.orderDate.isAfter(startOfToday)) // Filter for today's orders
        .toList()
      ..sort((a, b) =>
          b.orderDate.compareTo(a.orderDate)); // Sort by descending order date
  }

  // Function to load all orders without filtering
  List<OrderModel> getAllOrders() {
    return orders.toList()
      ..sort((a, b) =>
          b.orderDate.compareTo(a.orderDate)); // Sort by descending order date
  }

  // Fetch OTP for a given order
  Future<String?> fetchOtp(String orderId, String otp) async {
    try {
      OrderModel? order = await orderRepository.GetOtp(orderId, otp);

      if (order != null) {
        return order.otp;
      } else {
        throw 'No order found with the given Order ID and OTP.';
      }
    } catch (e) {
      throw 'Failed to fetch OTP: $e';
    }
  }

void checkOrderTime(BuildContext context) {
  // Get current time in IST
  DateTime now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30)); 

  // Define allowed time range (IST)
  TimeOfDay start = TimeOfDay(hour: 18, minute: 0); // 6:00 PM
  TimeOfDay end = TimeOfDay(hour: 20, minute: 0);   // 8:00 PM
  TimeOfDay current = TimeOfDay.fromDateTime(now);

  bool isAllowedTime = (current.hour > start.hour || 
                        (current.hour == start.hour && current.minute >= start.minute)) &&
                       (current.hour < end.hour || 
                        (current.hour == end.hour && current.minute <= end.minute));

  if (!isAllowedTime) {
    // Show alert if order is placed outside allowed time
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ordering Time Restriction"),
        content: Text("You can only place orders between 6 PM and 8 PM IST."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  } else {
    // Proceed with checkout
    processPrismaOrder();
  }
}

// Method for processing Prisma order with or without PhonePe Payment
void processPrismaOrder() async {
  try {
    // Start Loader
    TFullScreenLoader.openLoadingDialog(
        'Processing your order', TImages.successanimation);

    final authController = AuthController.instance;

String token = authController.authToken.value;
String userId = authController.userId.value;

print('Stored Token: $token');
print('Stored User ID: $userId');
    // final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null || userId.isEmpty) {
      TFullScreenLoader.stopLoading();
      return;
    }

    // Check if address is provided
  
      if (selectedAddress == null) {
        TLoaders.warningSnackBar(
            title: 'Address Required',
            message:
                'Please select a delivery address before proceeding to payment.');
        TFullScreenLoader.stopLoading();
        return;
      }


    // Check if the cart value is less than ₹200
    final cartController = CartController.instance;

    if (cartController.totalCartPrice.value < 1) {
      TLoaders.warningSnackBar(
        title: 'Minimum Order Value',
        message: 'Your SubTotal value must be at least ₹250 to proceed.',
      );
      TFullScreenLoader.stopLoading();
      return;
    }

    // Check if the store is closed
    if (await BrandRepository.isStoreClosed(
        cartController.cartItems.first.brandId)) {
      TLoaders.warningSnackBar(
          title: 'Store Closed',
          message: 'Store is closed. Please try again later.');
      TFullScreenLoader.stopLoading();
      return;
    }
    
    final brandController = Get.put(BrandController()); 
    final inCampusBrands = brandController.brandsToShow
    .where((brand) => brand.inCampus!)
    .toList();
    final hasInCampusBrand = inCampusBrands.isNotEmpty;

if (hasInCampusBrand) {
  if (checkoutController.selectedPaymentMethod == paymentMethods[1]) {
    await processPhonePePayment(TPricingCalculator.finalTotalPrice(
      cartController.totalCartPrice.value, 'IND.'));
  } else {
    // Show an error message to the user
    TFullScreenLoader.stopLoading();
    TLoaders.warningSnackBar(
          title: 'Only UPI available',
          message: 'Only PhonePe payment is allowed for in-campus orders.');
    return;
  }
} else {
  // Allow both payment methods for non in-campus brands
  if (checkoutController.selectedPaymentMethod == paymentMethods[0]) {
    // Proceed with the existing order processing logic
    await pushOrderToDatabase(userId, cartController);
  } else if (checkoutController.selectedPaymentMethod == paymentMethods[1]) {
    // Process payment using PhonePe SDK
    await processPhonePePayment(TPricingCalculator.finalTotalPrice(
      cartController.totalCartPrice.value, 'IND.'));
  } else {
    TFullScreenLoader.stopLoading();
    return;
  }
}
  } catch (e) {
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  }
}

// Helper method to push order to database
Future<void> pushOrderToDatabase(String userId, CartController cartController) async {
  List<Map<String, dynamic>> products = [];
  for (var item in cartController.cartItems) {
    if (item.takeoutQuantity > 0) {
      products.add({
        'productId': int.parse(item.productId),
        'quantity': item.takeoutQuantity,
        'takeaway': true,
      });
    }

    int remainingQuantity = item.quantity - item.takeoutQuantity;
    if (remainingQuantity > 0) {
      products.add({
        'productId': int.parse(item.productId),
        'quantity': remainingQuantity,
        'takeaway': false,
      });
    }
  }

  bool isPaid = checkoutController.selectedPaymentMethod == paymentMethods[1];

  await orderRepository.pushOrder(
    cartController.cartItems.first.brandId,
    // "VITAP, AndhraPradesh",
    selectedAddress!,
    TPricingCalculator.TotalPrice(
        cartController.totalCartPrice.value, 'IND.'),
    userId,
    products,
    TPricingCalculator.getDeliveryForLocation(cartController.totalCartPrice.value, 'IND.'),
    TPricingCalculator.getTaxRateForLocation(cartController.totalCartPrice.value, 'IND.'),
    TPricingCalculator.finalTotalPrice(cartController.totalCartPrice.value, 'IND.'),
    TPricingCalculator.getCGST(cartController.totalCartPrice.value, 'IND.'),
    TPricingCalculator.getSGST(cartController.totalCartPrice.value, 'IND.'),
    isPaid,
  );

  // Show success screen
  Get.off(() => SuccessScreen(
        image: TImages.successfulPaymentIcon,
        title: 'Order Processed',
        subtitle: 'Your item will be ready soon!',
        onPressed: () {
          Get.offAll(() => const NavigationMenu());
          NavigationController.instance.goToMyOrders();
        },
      ));

  // Clear the cart
  CartController.instance.clearCart();
}

// Helper method for PhonePe payment
Future<void> processPhonePePayment(double amount) async {
  try {
    final phonePe = PhonepePaymentGateway(context: Get.context!, amount: 1);
    phonePe.initializeSdk();
  } catch (e) {
    TLoaders.errorSnackBar(
        title: 'Payment Failed', message: 'PhonePe Payment Failed: $e');
  } finally {
    TFullScreenLoader.stopLoading();
  }
}


  void handleFcmTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      final localStorage = GetStorage();
      final userId = localStorage.read('user_id');
      // String userId = authRepo.authUser!.uid;
      await orderRepository.saveFcmTokenInPrisma(
          userId, newToken); // Save new token
      print("FCM token refreshed and saved");
    });
  }
}



  // void razorPayment() {
  //   // Check if the cart value is less than ₹200
  //   // double cartTotalPrice = TPricingCalculator.calculateTotalPrice(
  //   //     cartController.totalCartPrice.value, 'IND.');

  //   // if (cartTotalPrice < 200) {
  //   //   TLoaders.warningSnackBar(
  //   //       title: 'Minimum Order Value',
  //   //       message: 'Your order value must be at least ₹200 to proceed.');
  //   //   return;
  //   // }
  //   if (selectedAddress == null) {
  //     // Show a Snackbar message
  //     TLoaders.warningSnackBar(
  //         title: 'Address Required',
  //         message:
  //             'Please select a delivery address before proceeding to payment.');
  //     return;
  //   }
  //   Razorpay razorpay = Razorpay();
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onRazorPaymentSuccess);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onRazorPaymentError);

  //   var options = {
  //     'key': 'rzp_test_SlzyYEZl6aNqqQ',
  //     'amount': (TPricingCalculator.calculateTotalPrice(
  //                 cartController.totalCartPrice.value, 'IND.') *
  //             100)
  //         .toInt(),
  //     'name': 'Chuck-E-Cheez.',
  //     'description': 'cheezechoice Order',
  //     'prefill': {'email': AuthenticationRepository.instance.authUser!.email}
  //   };

  //   razorpay.open(options);
  // }

  // void _onRazorPaymentSuccess(PaymentSuccessResponse response) async {
  //   List<Map<String, dynamic>> products = [];
  //   for (var item in cartController.cartItems) {
  //     if (item.takeoutQuantity > 0) {
  //       products.add({
  //         'productId': int.parse(item.productId),
  //         'quantity': item.takeoutQuantity,
  //         'takeaway': true,
  //       });
  //     }

  //     int remainingQuantity = item.quantity - item.takeoutQuantity;
  //     if (remainingQuantity > 0) {
  //       products.add({
  //         'productId': int.parse(item.productId),
  //         'quantity': remainingQuantity,
  //         'takeaway': false,
  //       });
  //     }
  //   }

  //   await orderRepository.pushOrder(
  //     cartController.cartItems.first.brandId,
  //     // addressController.selectedAddress.value.toString(),
  //     selectedAddress!,
  //     TPricingCalculator.calculateTotalPrice(
  //         cartController.totalCartPrice.value, 'IND.'),
  //     AuthenticationRepository.instance.authUser!.uid,
  //     products,
  //     TPricingCalculator.getDeliveryForLocation(
  //         cartController.totalCartPrice.value, 'IND.'),
  //     TPricingCalculator.getTaxRateForLocation(
  //         cartController.totalCartPrice.value, 'IND.'),
  //     TPricingCalculator.finalTotalPrice(
  //         cartController.totalCartPrice.value, 'IND.'),
  //     TPricingCalculator.getCGST(cartController.totalCartPrice.value, 'IND.'),
  //     TPricingCalculator.getSGST(cartController.totalCartPrice.value, 'IND.'),
  //   );

  //   // Save FCM token to Prisma when the order is placed
  //   // await saveFcmTokenToPrisma();

  //   Get.off(() => SuccessScreen(
  //         image: TImages.successfulPaymentIcon,
  //         title: 'Payment Success',
  //         subtitle: 'Your item will be ready!',
  //         onPressed: () {
  //           // Navigate to 'My Orders' inside the Profile Tab
  //           Get.offAll(() => const NavigationMenu());
  //           NavigationController.instance.goToMyOrders();
  //         },
  //       ));

  //   //Update the cart status
  //   cartController.clearCart();
  // }

  // void _onRazorPaymentError(PaymentFailureResponse response) {
  //   Get.offAll(() => const NavigationMenu());
  //   TLoaders.errorSnackBar(
  //       title: 'Oh Snap!', message: 'Could not process payment.');
  // }




