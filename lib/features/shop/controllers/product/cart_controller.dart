import 'package:cheezechoice/common/widgets/loaders/loaders.dart';
import 'package:cheezechoice/features/shop/controllers/product/variation_controller.dart';
import 'package:cheezechoice/features/shop/models/cart_item_model.dart';
import 'package:cheezechoice/features/shop/models/order_model.dart';
import 'package:cheezechoice/features/shop/models/product_model.dart';
import 'package:cheezechoice/utils/enums/enums.dart';
import 'package:cheezechoice/utils/local_storage/storage_utility.dart';
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
    // Check if the quantity to add is valid
    if (productQuantityInCart.value < 1) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }

    // Get available stock directly from the product model
    int availableStock = product.stock;

    // Handle variations
    if (product.productType == ProductType.variable.toString()) {
      if (variationController.selectedVariation.value.id.isEmpty) {
        TLoaders.customToast(message: 'Select Variation');
        return;
      }

      // Override stock with selected variation's stock
      availableStock = variationController.selectedVariation.value.stock;
      if (availableStock < 1) {
        TLoaders.warningSnackBar(
            message: 'Selected variation is out of stock', title: 'Oh Snap!');
        return;
      }
    } else {
      // Check stock for simple products
      if (availableStock < 1) {
        TLoaders.warningSnackBar(
            message: 'Selected product is out of stock', title: 'Oh Snap!');
        return;
      }
    }

    // Convert product to a cart item
    final CartItemModel selectedCartItem =
        convertToCartItem(product, productQuantityInCart.value);

    // Check if the product/variation is already in the cart
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    // Calculate the current quantity in the cart for this product/variation
    int currentCartQuantity = index >= 0 ? cartItems[index].quantity : 0;

    // Validate against available stock
    if (currentCartQuantity + productQuantityInCart.value > availableStock) {
      TLoaders.warningSnackBar(
          message: 'Cannot add more items. Only $availableStock in stock.',
          title: 'Stock Limit Reached');
      return;
    }

    

    // Add or update cart item
    if (index >= 0) {
      cartItems[index].quantity += productQuantityInCart.value;
    } else {
      cartItems.add(selectedCartItem);
    }

    // Update cart state
    updateCart();
    TLoaders.customToast(message: 'Your Product has been added to the Cart.');
  }

  void incrementQuantity(ProductModel product) {
    final int availableStock =
        product.productType == ProductType.variable.toString()
            ? variationController.selectedVariation.value.stock
            : product.stock;

    if (productQuantityInCart.value >= availableStock) {
      TLoaders.customToast(
          message: 'Cannot exceed available stock ($availableStock)');
      return;
    }

    productQuantityInCart.value++;
  }

  void decrementQuantity() {
    if (productQuantityInCart.value > 1) {
      productQuantityInCart.value--;
    } else {
      TLoaders.customToast(message: 'Minimum quantity is 1');
    }
  }

  // void addOneProductToCart(ProductModel product) {
  //   addOneToCart(convertToCartItem(product, 1));
  // }
  void addOneProductToCart(ProductModel product) {
    final CartItemModel cartItem = convertToCartItem(product, 1);
    addOneToCart(cartItem);
  }

  void removeOneProductFromCart(ProductModel product) {
    removeOneFromCart(convertToCartItem(product, 1));
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);

    // Get the available stock based on product type
    int availableStock = item.selectedVariation != null
        ? variationController.selectedVariation.value.stock
        : item.productId != null
            ? item.stock
            : 0;

    if (cartItems.isNotEmpty) {
      CartItemModel cartItem = cartItems.first;
      if (cartItem.brandId != item.brandId) {
        TLoaders.warningSnackBar(
            message:
                'You can only add products from the same restaurant to your cart!',
            title: 'Oh Snap!');
        return;
      }
    }

    // Check if adding one more item exceeds stock
    if (index >= 0) {
      if (cartItems[index].quantity >= availableStock) {
        TLoaders.warningSnackBar(
            message: 'Cannot add more items. Only $availableStock in stock.',
            title: 'Stock Limit Reached');
        return;
      }
      cartItems[index].quantity += 1;
    } else {
      // Ensure the initial addition respects stock
      if (item.quantity > availableStock) {
        TLoaders.warningSnackBar(
            message: 'Cannot add more items. Only $availableStock in stock.',
            title: 'Stock Limit Reached');
        return;
      }
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
    int availableStock = isVariation ? variation.stock : product.stock;
    // final price = isVariation
    //     ? variation.salePrice > 0.0
    //         ? variation.salePrice
    //         : variation.price
    //     : product.salePrice > 0.0
    //         ? product.salePrice
    //         : product.price;
    final price = product.price;

    return CartItemModel(
      productId: product.id,
      quantity: quantity,
      title: product.title,
      price: price,
      variationId: variation.id,
      image: isVariation ? variation.image : product.thumbnail,
      brandId: product.brand != null ? int.parse(product.brand!.id) : 0,
      brandName: product.brand != null ? product.brand!.name : ' ',
      selectedVariation: isVariation ? variation.attributeValues : null,
      stock: availableStock,
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
