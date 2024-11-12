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
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  final RxInt filterDays = 5.obs;
  final RxString filterLabel = 'Recent Orders'.obs;
  var isLoading = false.obs;
  String? selectedAddress;

  final authRepo = Get.put(AuthenticationRepository());
  final FirebaseMessaging firebaseMessaging =
      FirebaseMessaging.instance; // Firebase Messaging instance

  void setSelectedAddress(String address) {
    selectedAddress = address;
  }

  // Method to fetch and save FCM token to Prisma when the user orders
  Future<void> saveFcmTokenToPrisma() async {
    try {
      String? fcmToken = await firebaseMessaging.getToken();
      print("FCM Token: $fcmToken");
      // Fetch FCM token
      if (fcmToken != null) {
        String userId = authRepo.authUser!.uid;
        await orderRepository.saveFcmTokenInPrisma(userId, fcmToken);
        print("FCM token saved successfully");
      } else {
        print("Failed to fetch FCM token");
      }
    } catch (e) {
      print("Error fetching or saving FCM token: $e");
    }
  }

  // order status for OTP
  List<OrderModel> getOrdersByStatus(String status) {
    return orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Function to determine if the section should be available
  bool isAvailable() {
    final now = DateTime.now();
    final startAvailability =
        DateTime(now.year, now.month, now.day, 18); // Saturday 5:00 PM
    final endAvailability =
        DateTime(now.year, now.month, now.day, 20); // Monday 8:00 PM

    // Check if today is between Saturday 5:00 PM and Monday 8:00 PM
    final dayOfWeek = now.weekday;
    final isSaturdayEvening =
        dayOfWeek == DateTime.saturday && now.isAfter(startAvailability);
    final isSunday = dayOfWeek == DateTime.sunday;
    final isMondayMorning =
        dayOfWeek == DateTime.monday && now.isBefore(endAvailability);

    return isSaturdayEvening || isSunday || isMondayMorning;
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

  // Function to retrieve recent orders
  List<OrderModel> getRecentOrders() {
    final DateTime now = DateTime.now();
    final DateTime filterDate = now.subtract(Duration(days: filterDays.value));
    return orders
        .where((order) => order.orderDate.isAfter(filterDate))
        .toList();
  }

  // Function to load all orders without filtering
  List<OrderModel> getAllOrders() {
    return orders.toList(); // Simply returns the entire list of orders
  }

  // Fetch OTP for a given order
  Future<String?> fetchOtp(String orderId, String otp) async {
    try {
      // Call the repository method to get the order details with the OTP
      OrderModel? order = await orderRepository.GetOtp(orderId, otp);

      if (order != null) {
        return order.otp; // Return the OTP
      } else {
        throw 'No order found with the given Order ID and OTP.';
      }
    } catch (e) {
      throw 'Failed to fetch OTP: $e';
    }
  }

  void razorPayment() {
    // Check if the cart value is less than ₹200
    // double cartTotalPrice = TPricingCalculator.calculateTotalPrice(
    //     cartController.totalCartPrice.value, 'IND.');

    // if (cartTotalPrice < 200) {
    //   TLoaders.warningSnackBar(
    //       title: 'Minimum Order Value',
    //       message: 'Your order value must be at least ₹200 to proceed.');
    //   return;
    // }
    if (selectedAddress == null) {
      // Show a Snackbar message
      TLoaders.warningSnackBar(
          title: 'Address Required',
          message:
              'Please select a delivery address before proceeding to payment.');
      return;
    }
    Razorpay razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onRazorPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onRazorPaymentError);

    var options = {
      'key': 'rzp_test_SlzyYEZl6aNqqQ',
      'amount': (TPricingCalculator.calculateTotalPrice(
                  cartController.totalCartPrice.value, 'IND.') *
              100)
          .toInt(),
      'name': 'Chuck-E-Cheez.',
      'description': 'cheezechoice Order',
      'prefill': {'email': AuthenticationRepository.instance.authUser!.email}
    };

    razorpay.open(options);
  }

  void _onRazorPaymentSuccess(PaymentSuccessResponse response) async {
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

    await orderRepository.pushOrder(
      cartController.cartItems.first.brandId,
      // addressController.selectedAddress.value.toString(),
      selectedAddress!,
      TPricingCalculator.calculateTotalPrice(
          cartController.totalCartPrice.value, 'IND.'),
      AuthenticationRepository.instance.authUser!.uid,
      products,
    );

    // Save FCM token to Prisma when the order is placed
    await saveFcmTokenToPrisma();

    Get.off(() => SuccessScreen(
          image: TImages.successfulPaymentIcon,
          title: 'Payment Success',
          subtitle: 'Your item will be ready!',
          onPressed: () {
            // Navigate to 'My Orders' inside the Profile Tab
            Get.offAll(() => const NavigationMenu());
            NavigationController.instance.goToMyOrders();
          },
        ));

    //Update the cart status
    cartController.clearCart();
  }

  void _onRazorPaymentError(PaymentFailureResponse response) {
    Get.offAll(() => const NavigationMenu());
    TLoaders.errorSnackBar(
        title: 'Oh Snap!', message: 'Could not process payment.');
  }

  // Method for processing Prisma order without Razorpay
  void processPrismaOrder() async {
    try {
      // Start Loader
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.daceranimation);

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Check if address is provided
      if (isAvailable()) {
        if (selectedAddress == null) {
          TLoaders.warningSnackBar(
              title: 'Address Required',
              message:
                  'Please select a delivery address before proceeding to payment.');
          TFullScreenLoader.stopLoading();
          return;
        }
      }
      // Check if the cart value is less than ₹200
      double cartTotalPrice = TPricingCalculator.calculateTotalPrice(
          cartController.totalCartPrice.value, 'IND.');

      if (cartTotalPrice.isLowerThan(180)) {
        TLoaders.warningSnackBar(
          title: 'Minimum Order Value',
          message: 'Your order value must be at least ₹180 to proceed.',
        );
        return; // Exit the function early if the total is less than ₹200
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

      // Check payment method
      if (checkoutController.selectedPaymentMethod == paymentMethods[0]) {
        // Prepare product details
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

        // Push the order to the database
        await orderRepository.pushOrder(
          cartController.cartItems.first.brandId,
          selectedAddress!,
          TPricingCalculator.calculateTotalPrice(
              cartController.totalCartPrice.value, 'IND.'),
          userId,
          products,
        );

        // Save FCM token to Prisma when the order is placed
        await saveFcmTokenToPrisma();

        // Show success screen
        Get.off(() => SuccessScreen(
              image: TImages.successfulPaymentIcon,
              title: 'Order Processed',
              subtitle: 'Your item will be ready soon!',
              onPressed: () {
                // Navigate to 'My Orders' inside the Profile Tab
                Get.offAll(() => const NavigationMenu());
                NavigationController.instance.goToMyOrders();
              },
            ));

        // Clear the cart
        cartController.clearCart();
      } else {
        TFullScreenLoader.stopLoading();
        return;
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void handleFcmTokenRefresh() {
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      String userId = authRepo.authUser!.uid;
      await orderRepository.saveFcmTokenInPrisma(
          userId, newToken); // Save new token
      print("FCM token refreshed and saved");
    });
  }
}
//   void processPrismaOrder() async {
//     try {
//       // Start Loader
//       TFullScreenLoader.openLoadingDialog(
//           'Processing your order', TImages.daceranimation);
//       // Get user authentication Id
//       final userId = AuthenticationRepository.instance.authUser?.uid;
//       if (userId!.isEmpty) return;
//       if (checkoutController.selectedPaymentMethod == paymentMethods[1]) {
//         if (await BrandRepository.isStoreClosed(
//             cartController.cartItems.first.brandId)) {
//           TLoaders.warningSnackBar(
//             title: 'Store Closed',
//             message: 'Store is closed. Please try again later.',
//           );
//           cartController.clearCart();
//           Get.offAll(() => const NavigationMenu());
//           return;
//         }
//         razorPayment();
//       } else {
//         return;
//       }
//     } catch (e) {
//       TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
//     }
//   }

//   // Add methods for order processing
//   // void processOrder(double totalAmount) async {
//   //   try {
//   //     // Start Loader
//   //     TFullScreenLoader.openLoadingDialog(
//   //         'Processing your order', TImages.daceranimation);
//   //     // Get user authentication Id
//   //     final userId = AuthenticationRepository.instance.authUser?.uid;
//   //     if (userId!.isEmpty) return;
//   //     // Add details
//   //     final order = OrderModel(
//   //       //generating unique id
//   //       id: UniqueKey().toString(),
//   //       userId: userId,
//   //       status: OrderStatus.pending.toString(),
//   //       totalAmount: totalAmount,
//   //       orderDate: DateTime.now(),
//   //       paymentMethod: checkoutController.selectedPaymentMethod.value.name,
//   //       address: addressController.selectedAddress.value,
//   //       // Set date as needed
//   //       deliveryDate: DateTime.now(),
//   //       items: cartController.cartItems.toList(),
//   //     );
//   //     // Save the orders to Firestore
//   //     await orderRepository.saveOrder(order, userId);
//   //     //Update the cart status
//   //     cartController.clearCart();
//   //     //Show sucess screen
//   //     Get.off(() => SuccessScreen(
//   //           image: TImages.successfulPaymentIcon,
//   //           title: 'Payment Sucess',
//   //           subtitle: 'Your item will be ready!',
//   //           onPressed: () => Get.offAll(() => const NavigationMenu()),
//   //         ));
//   //   } catch (e) {
//   //     TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
//   //   }
//   // }

//    // Additional logic for refreshing token
//   void handleFcmTokenRefresh() {
//     firebaseMessaging.onTokenRefresh.listen((newToken) async {
//       String userId = authRepo.authUser!.uid;
//       await orderRepository.saveFcmTokenInPrisma(userId, newToken); // Save new token
//       print("FCM token refreshed and saved");
//     });
//   }
// }

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
// import 'package:cheezechoice/common/widgets/success_screen/success_screen.dart';
// import 'package:cheezechoice/data/repositories/authentication_repo.dart';
// import 'package:cheezechoice/data/repositories/brands/brand_repository.dart';
// import 'package:cheezechoice/data/repositories/order/order_repo.dart';
// import 'package:cheezechoice/features/personalisation/controllers/address_controller.dart';
// import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
// import 'package:cheezechoice/features/shop/controllers/product/checkout_controller.dart';
// import 'package:cheezechoice/features/shop/models/order_model.dart';
// import 'package:cheezechoice/features/shop/models/payment_method_model.dart';
// import 'package:cheezechoice/features/shop/screens/checkout/widgets/order_type.dart';
// import 'package:cheezechoice/navigation_menu.dart';
// import 'package:cheezechoice/utils/constants/enums.dart';
// import 'package:cheezechoice/utils/constants/image_strings.dart';
// import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';
// import 'package:cheezechoice/utils/popups/fullScreenLoader.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class OrderController extends GetxController {
//   static OrderController get instance => Get.find();

//   final cartController = CartController.instance;
//   final addressController = AddressController.instance;
//   final checkoutController = CheckoutController.instance;
//   final orderRepository = Get.put(OrderRepository());
//   final RxList<OrderModel> orders = <OrderModel>[].obs;
//   final Rx<OrderType> orderType = OrderType.dineIn.obs;
//   final RxBool parcelChargeProcessing = false.obs;
//   final RxInt parcelCharge = 0.obs;
//   final RxInt filterDays = 5.obs;
//   final RxString filterLabel = 'Recent Orders'.obs;
//   var isLoading = false.obs;

//   final authRepo = Get.put(AuthenticationRepository()); 
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance; // Firebase Messaging instance

  

//   // Method to fetch and save FCM token to Prisma when the user orders
//   Future<void> saveFcmTokenToPrisma() async {
//   try {
//     String? fcmToken = await firebaseMessaging.getToken();
//     print("FCM Token: $fcmToken");

//     if (fcmToken != null) {
//       // Get the current user ID
//       String? userId = AuthenticationRepository.instance.authUser?.uid;
//       if (userId == null) {
//         throw 'Unable to get user ID';
//       }

//       await orderRepository.saveFcmTokenInPrisma(userId, fcmToken);
//       print("FCM token saved successfully");
//     } else {
//       print("Failed to fetch FCM token");
//     }
//   } catch (e) {
//     print("Error fetching or saving FCM token: $e");
//   }
// }




//   // order status for OTP
//   List<OrderModel> getOrdersByStatus(String status) {
//     return orders
//         .where((order) => order.status.toLowerCase() == status.toLowerCase())
//         .toList();
//   }

//   Future<void> calculateParcelCharges() async {
//     parcelChargeProcessing.value = true;
//     final cart = CartController.instance;
//     parcelCharge.value = 0;
//     try {
//       Map<String, dynamic> parcelChargeData =
//           await BrandRepository.getParcelCharges(cart.cartItems.first.brandId);

//       if (parcelChargeData['parcelPerItem'] ?? true) {
//         cart.cartItems.forEach((element) {
//           if (element.takeoutQuantity > 0)
//             parcelCharge.value +=
//                 ((parcelChargeData['parcelCharge'] as num).toInt() *
//                     element.takeoutQuantity);
//         });
//       } else {
//         parcelCharge.value = (parcelChargeData['parcelCharge'] as num).toInt();
//       }
//     } on Exception catch (e) {
//       TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
//     }

//     parcelChargeProcessing.value = false;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserOrders();
//     handleFcmTokenRefresh();
//   }

//   Future<void> fetchUserOrders() async {
//     isLoading.value = true;
//     try {
//       orders.value = await orderRepository.fetchUserOrdersPrisma();
//       // Initially set the recent orders filter
//       filterOrdersByDays(5, 'Recent Orders');
//     } finally {
//       isLoading.value = false;
//     }
//   }

  // void filterOrdersByDays(int days, String label) {
  //   filterDays.value = days;
  //   filterLabel.value = label;
  // }

  // List<OrderModel> getRecentOrders() {
  //   final DateTime now = DateTime.now();
  //   final DateTime filterDate = now.subtract(Duration(days: filterDays.value));
  //   return orders
  //       .where((order) => order.orderDate.isAfter(filterDate))
  //       .toList();
  // }

  // // Comment out the Razorpay payment process method
  // // void razorPayment() {
  // //   Razorpay razorpay = Razorpay();
  // //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onRazorPaymentSuccess);
  // //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onRazorPaymentError);

  // //   var options = {
  // //     'key': 'rzp_test_SlzyYEZl6aNqqQ',
  // //     'amount': (TPricingCalculator.calculateTotalPrice(
  // //                 cartController.totalCartPrice.value, 'IND.') *
  // //             100)
  // //         .toInt(),
  // //     'name': 'Chuck-E-Cheez.',
  // //     'description': 'cheezechoice Order',
  // //     'prefill': {'email': AuthenticationRepository.instance.authUser!.email}
  // //   };

  // //   razorpay.open(options);
  // // }

  // // Method for processing Prisma order without Razorpay
  // void processPrismaOrder() async {
  //   try {
  //     // Start Loader
  //     TFullScreenLoader.openLoadingDialog(
  //         'Processing your order', TImages.daceranimation);
  //     // Get user authentication Id
  //     final userId = AuthenticationRepository.instance.authUser?.uid;
  //     if (userId!.isEmpty) return;
      
  //     // Add products and order details for Prisma
  //     List<Map<String, dynamic>> products = [];
  //     for (var item in cartController.cartItems) {
  //       if (item.takeoutQuantity > 0) {
  //         products.add({
  //           'productId': int.parse(item.productId),
  //           'quantity': item.takeoutQuantity,
  //           'takeaway': true,
  //         });
  //       }

  //       int remainingQuantity = item.quantity - item.takeoutQuantity;
  //       if (remainingQuantity > 0) {
  //         products.add({
  //           'productId': int.parse(item.productId),
  //           'quantity': remainingQuantity,
  //           'takeaway': false,
  //         });
  //       }
  //     }

  //     await orderRepository.pushOrder(
  //       cartController.cartItems.first.brandId,
  //       addressController.selectedAddress.value.toString(),
  //       TPricingCalculator.calculateTotalPrice(
  //           cartController.totalCartPrice.value, 'IND.'),
  //       AuthenticationRepository.instance.authUser!.uid,
  //       products,
  //     );

  //     // Save FCM token to Prisma when the order is placed
  //     await saveFcmTokenToPrisma();

  //     Get.off(() => SuccessScreen(
  //           image: TImages.successfulPaymentIcon,
  //           title: 'Order Processed',
  //           subtitle: 'Your item will be ready soon!',
  //           onPressed: () => Get.offAll(() => const NavigationMenu()),
  //         ));

  //     //Update the cart status
  //     cartController.clearCart();
  //   } catch (e) {
  //     TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //   }
  // }

  //  void handleFcmTokenRefresh() {
  //   firebaseMessaging.onTokenRefresh.listen((newToken) async {
  //     String userId = authRepo.authUser!.uid;
  //     await orderRepository.saveFcmTokenInPrisma(userId,newToken); // Save new token
  //     print("FCM token refreshed and saved");
  //   });
  // }

  // Commented out Razorpay event handlers
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
  //     addressController.selectedAddress.value.toString(),
  //     TPricingCalculator.calculateTotalPrice(
  //         cartController.totalCartPrice.value, 'IND.'),
  //     AuthenticationRepository.instance.authUser!.uid,
  //     products,
  //   );

  //   // Save FCM token to Prisma when the order is placed
  //   await saveFcmTokenToPrisma();

  //   Get.off(() => SuccessScreen(
  //         image: TImages.successfulPaymentIcon,
  //         title: 'Payment Success',
  //         subtitle: 'Your item will be ready!',
  //         onPressed: () => Get.offAll(() => const NavigationMenu()),
  //       ));

  //   cartController.clearCart();
  // }

  // Commented out Razorpay error handler
  // void _onRazorPaymentError(PaymentFailureResponse response) {
  //   TLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Payment Failed');
  // }
//}
