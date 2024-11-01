import 'package:food/common/widgets/loaders/loaders.dart';
import 'package:food/features/shop/controllers/product/variation_controller.dart';
import 'package:food/features/shop/models/brand_model.dart';
import 'package:food/features/shop/models/cart_item_model.dart';
import 'package:food/features/shop/models/order_model.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/enums/enums.dart';
import 'package:food/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

//Variable
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;

  CartController() {
    loadCartItems();
  }

  //Add items to the cart
  void addToCart(ProductModel product) {
    //Quantity Check
    if (productQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }
//Variation
    if (product.productType == ProductType.variable.toString() &&
        variationController.selectedVariation.value.id.isEmpty) {
      TLoaders.customToast(message: 'Select Variation');
      return;
    }
//Out of Stock
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.stock < 1) {
        TLoaders.warningSnackBar(
            message: 'Select Variation is out of stock', title: 'Oh Snap!');
        return;
      }
    } else {
      if (product.stock < 1) {
        TLoaders.warningSnackBar(
            message: 'Selected Product is out of stock', title: 'Oh Snap!');
        return;
      }
    }

    //convert the productModel to a cartModel with the given quantity
    final selectedCartItem =
        convertToCartItem(product, productQuantityInCart.value);
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    if (index >= 0) {
      //this quantity is already added or updated/removed from the design
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: 'Your Product has been added to the Cart.');
  }

  void addOneProductToCart(ProductModel product) {
    addOneToCart(convertToCartItem(product, 1));
  }

  void removeOneProductFromCart(ProductModel product) {
    removeOneFromCart(convertToCartItem(product, 1));
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    if (cartItems.isNotEmpty) {
      CartItemModel cartItem = cartItems.first;
      if (cartItem.brandId != item.brandId) {
        TLoaders.warningSnackBar(
            message: 'You can only add products from the same brand',
            title: 'Oh Snap!');
        return;
      }
    }

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }
    updateCart();
  }

  void repeatOrder(OrderModel order) {
    clearCart();
    cartItems.assignAll(order.items);
    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems[index].quantity == 1
            ? removeFromCartDialog(index)
            : cartItems.removeAt(index);
      }
      updateCart();
    }
  }

  void removeFromCartDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        //remove item
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Product Removed from the Cart.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void updateAlreadyAddedProductCount(ProductModel product) {
    //if product has no variations then calculate cartentries and display total number
    //ele make default entries to 0 and show cartentries when variation is selected
    if (product.productType == ProductType.single.toString()) {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    } else {
      //get selected variation if any...
      final variationId = variationController.selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value =
            getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }

  //Function converts a productModel to a CartItem Model
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == ProductType.single.toString()) {
      //reset variation in case of singlr product type
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.id.isNotEmpty;
    final price = isVariation
        ? variation.salePrice > 0.0
            ? variation.salePrice
            : variation.price
        : product.salePrice > 0.0
            ? product.salePrice
            : product.price;

    return CartItemModel(
      productId: product.id,
      quantity: quantity,
      title: product.title,
      price: price,
      variationId: variation.id,
      image: isVariation ? variation.image : product.thumbnail,
      brandId: product.brand != null ? int.parse(product.brand!.id) : 0,
      brandName: product.brand !=null ? product.brand!.name : ' ',
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    TLocalStorage.instance().saveData('cartItems', cartItemStrings);
  }

  void loadCartItems() {
    final cartItemStrings =
        TLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foudnItem = cartItems.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItemModel.empty(),
    );
    return foudnItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
