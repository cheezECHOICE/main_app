import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/features/personalisation/screens/address/widgets/addressmodel.dart';
import 'package:food/features/shop/models/cart_item_model.dart';
import 'package:food/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final String status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final String otp;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paytm',
    this.address,
    this.deliveryDate,
    required this.otp,
  });

  String get formattedOrderDate =>
      THelperFunctions.getFormattedDateTime(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDateTime(deliveryDate!)
      : '';

  get date => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'otp': otp, // Enum to string
      'totalAmount': totalAmount,
      'orderDate': formattedOrderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(), // Convert Address Model to map
      'deliveryDate': deliveryDate,
      'items': items
          .map((item) => item.toJson())
          .toList(), // Convert CartItemModel to map
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: data['status'],
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['payment Method'] as String,
      otp: data['otp'] as String,
      address: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
      deliveryDate: data['deliveryDate'] == null
          ? null
          : (data['deliveryDate'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>)
          .map((itemData) =>
              CartItemModel.fromJson(itemData as Map<String, dynamic>))
          .toList(),
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['orderId'].toString(),
      userId: json['userId'],
      status: json['orderStatus'],
      totalAmount: json['totalAmount'].toDouble(),
      orderDate: DateTime.parse(json['orderedAt']),
      paymentMethod: '',
      address: AddressModel.empty().copyWith(street: json['address']),
      otp: json['otp'].toString(),
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate']),
      items: (json['orderProducts'] as List<dynamic>)
          .map((itemData) => CartItemModel.fromPrismaOrders(
              itemData['product'], itemData['quantity']))
          .toList(),
    );
  }

  factory OrderModel.fromProduct(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'].toString(),
      userId: data['userId'] ?? '',
      status: data['orderStatus'] ?? '',
      otp: data['otp'], 
      items: [], 
      totalAmount: data['totalAmount'].toDouble(),
       orderDate: data['orderedAt'].DateTime(),
    );
  }
}
