import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:cheezechoice/data/repositories/authentication_repo.dart';
import 'package:cheezechoice/features/shop/models/order_model.dart';
import 'package:cheezechoice/utils/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final orderEndpoint = '$dbLink/orders';
  final userOrderEndpoint = '$dbLink/orders?userId=';
  final getbrandName =  '$dbLink/orders/get_brand?orderId=';

  /// Get the FCM Token
  Future<String?> getFcmToken() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken == null) {
        throw 'Unable to get FCM token';
      }
      return fcmToken;
    } catch (e) {
      print('Error fetching FCM token: $e');
      rethrow;
    }
  }

  /// Store FCM Token in Prisma
  Future<void> saveFcmTokenInPrisma(String userId, String? fcmToken) async {
    try {
      if (fcmToken != null) {
        await Dio().post('$dbLink/user', data: {
          'id': userId,
          'fcmToken': fcmToken,
        });
      }
    } catch (e) {
      print('Error updating FCM token: $e');
      throw 'Something went wrong while updating FCM Token.';
    }
  }

  /// Get all order related to current User
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId!.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes.';
      }
      final result =
          await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching Order Information. Try again later';
    }
  }

  /// Store new user order
  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(order.toJson());
    } catch (e) {
      throw 'Something went wrong while saving Order Information. Try again later';
    }
  }

  // Prisma order
  Future<void> pushOrder(int brandId, String address, 
  double totalAmount,
      String userId, List<Map<String, dynamic>> products,double deliveryPrice, double platformFee, double finalTotalAmount, double CGST, double SGST) async {
        
    try {
      await Dio().post(orderEndpoint, data: {
        'brandId': brandId,
        'address': address,
        'totalamount': totalAmount,
        'userId': userId,
        'products': products,
        'deliveryPrice':deliveryPrice,
        'platformFee':platformFee,
        'finalTotalAmount': finalTotalAmount,
        'cGST':CGST,
        'sGST':SGST,
      });
      // // Update FCM token when placing an order
      String? fcmToken = await getFcmToken();
      await saveFcmTokenInPrisma(userId, fcmToken);
    } catch (e) {
      throw 'Something went wrong while saving Order Information. Try again later';
    }
  }

  // Fetch user orders
  Future<List<OrderModel>> fetchUserOrdersPrisma() async {
    List<OrderModel> orders = [];
    try {
      var data = await Dio().get(
          '${userOrderEndpoint}${AuthenticationRepository.instance.authUser?.uid}');

      for (var item in data.data['data']) {
        orders.add(OrderModel.fromJson(item));
      }
    } catch (e) {
      print(e);
      throw 'Something went wrong while fetching Order Information. Try again later';
    }
    return orders;
  }

  Future<OrderModel?> GetOtp(String orderId, String otp) async {
    try {
      var response = await Dio().get(orderEndpoint, queryParameters: {
        'orderId': orderId,
        'otp': otp,
      });

      // Print the API response for debugging
      print('API Response: ${response.data}');

      // Check if the response contains a list of orders
      if (response.data != null && response.data['data'] is List) {
        var dataList = response.data['data'] as List;

        // Find the matching order by orderId
        var matchingOrder = dataList.firstWhere(
          (order) => order['orderId'].toString() == orderId,
          orElse: () => null,
        );

        if (matchingOrder != null) {
          // Return the order details
          return OrderModel.fromJson(matchingOrder as Map<String, dynamic>);
        } else {
          print('No matching order found for orderId: $orderId');
          return null;
        }
      } else {
        print('No valid data found in response');
        return null;
      }
    } catch (e) {
      print('Error fetching OTP: $e');
      throw 'Something went wrong while fetching the OTP for the order.';
    }
  }

   /// Fetch brand name by orderId
  Future<String?> fetchBrandName(String orderId) async {
    try {
      var response = await Dio().get(getbrandName);
      
      if (response.statusCode == 200 && response.data != null) {
        // Extract and return the brand name
        return response.data['name'];
      } else {
        print('Failed to fetch brand name');
        return null;
      }
    } catch (e) {
      print('Error fetching brand name: $e');
      throw 'Something went wrong while fetching the brand name.';
    }
  }
}

