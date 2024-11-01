import 'package:flutter/material.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/controllers/product/order_controller.dart';
import 'package:food/features/shop/models/cart_item_model.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class OrderTypeButton extends StatelessWidget {
  final OrderController controller = OrderController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TRoundedContainer(
        showBorder: true,
        backgroundColor:
            THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.white,
        padding: const EdgeInsets.only(
            top: TSizes.sm,
            bottom: TSizes.sm,
            right: TSizes.sm,
            left: TSizes.md),
        child: Row(
          children: [
            Text(
              'Select Type of Order',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: controller.orderType.value.name,
              icon: Icon(Icons.arrow_downward_rounded),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: TColors.primary,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.orderType.value =
                      OrderType.values.firstWhere((e) => e.name == newValue);
                }

                CartController cart = CartController.instance;
                if (OrderType.stringToEnum(newValue!) == OrderType.dineIn) {
                  cart.cartItems.forEach((element) {
                    element.takeoutQuantity = 0;
                  });
                } else if (OrderType.stringToEnum(newValue) ==
                    OrderType.takeout) {
                  OrderController.instance.calculateParcelCharges();
                  cart.cartItems.forEach((element) {
                    element.takeoutQuantity = element.quantity;
                  });
                } else {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Product",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Parcel",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cart.cartItems.length,
                            itemBuilder: (context, index) => OrderTypeSelection(
                              item: cart.cartItems[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              items: OrderType.values
                  .map<DropdownMenuItem<String>>((OrderType value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
      );
    });
  }
}

class OrderTypeSelection extends StatefulWidget {
  final CartItemModel item;

  const OrderTypeSelection({super.key, required this.item});

  @override
  State<OrderTypeSelection> createState() => _OrderTypeSelectionState();
}

class _OrderTypeSelectionState extends State<OrderTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.item.title),
        trailing: DropdownButton<int>(
          value: widget.item.takeoutQuantity,
          icon: Icon(Icons.arrow_downward_rounded),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: TColors.primary,
          ),
          onChanged: (int? newValue) {
            OrderController.instance.calculateParcelCharges();
            setState(() {
              widget.item.takeoutQuantity = newValue!;
            });
          },
          items: List.generate(widget.item.quantity + 1, (index) {
            return DropdownMenuItem(
              value: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(index.toString()),
              ),
            );
          }),
        ));
  }
}

enum OrderType {
  dineIn,
  takeout,
  choose;

  String get name {
    switch (this) {
      case OrderType.dineIn:
        return "Dine-in";
      case OrderType.takeout:
        return "Takeout";
      case OrderType.choose:
        return "Choose";
      default:
        return "";
    }
  }

  static OrderType stringToEnum(String value) {
    switch (value) {
      case "Takeout":
        return OrderType.takeout;
      case "Choose":
        return OrderType.choose;
      default:
        return OrderType.dineIn;
    }
  }
}
