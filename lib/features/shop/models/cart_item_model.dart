class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  int brandId;
  String? brandName;
  Map<String, String>? selectedVariation;
  int takeoutQuantity = 0;
  int stock;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.brandId,
    this.variationId = '',
    this.image,
    this.price = 0.0,
    this.title = '',
    this.selectedVariation,
    required this.brandName,
    required this.stock,
  });

  ///Empty Cart
  static CartItemModel empty() => CartItemModel(
      productId: '', quantity: 0, brandId: 0, brandName: '', stock: 0);

  ///Convert a CartItem to a JSON MAP

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandId': brandId,
      'selectedVariation': selectedVariation,
      'name': brandName,
      'stock': stock,
    };
  }

  //Create a cartItem from a JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      title: json['title'],
      price: json['price']?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      variationId: json['variationId'],
      brandId: json['brandId'] ?? 0,
      stock: json['stock'] ?? 0,
      brandName: json['name'] ?? '',
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, String>.from(json['selectedVariation'])
          : null,
    );
  }

  factory CartItemModel.fromPrismaOrders(
      Map<String, dynamic> json, int quantity) {
    return CartItemModel(
      productId: json['id'].toString(),
      title: json['name'],
      price: json['price']?.toDouble(),
      image: json['imgurl'],
      quantity: quantity,
      brandId: json['brandId'] ?? 0,
      stock: json['stock'] ?? 0,
      brandName: json['brandName'] ?? '',
    );
  }
}
