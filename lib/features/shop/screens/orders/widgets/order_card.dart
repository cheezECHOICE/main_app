import 'package:flutter/material.dart';
import 'package:food/common/styles/TRoundedContainer.dart';
import 'package:food/features/shop/controllers/product/cart_controller.dart';
import 'package:food/features/shop/models/order_model.dart';
import 'package:food/features/shop/screens/checkout/checkout.dart';
import 'package:food/features/shop/screens/orders/widgets/orders_otp.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;

  const OrderCard(this.order, {super.key});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 4),
      backgroundColor:
          THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.align_vertically),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text("Order id: ",
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(
                widget.order.id,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              Text(
                '\Rs.${widget.order.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              const Icon(Iconsax.shop),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              for (var item in widget.order.items)
                if (item.brandName != null)
                  Text(
                    item.brandName!, // Replace with actual brand name
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Divider(thickness: 1),
          const SizedBox(height: TSizes.spaceBtwItems),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Icon(
                  _isExpanded ? Iconsax.arrow_down_14 : Iconsax.arrow_right_3,
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: _isExpanded ? 1 : 0,
              end: _isExpanded ? 1 : 0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return ClipRect(
                child: Align(
                  heightFactor: value,
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                for (var item in widget.order.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: TColors.primary.withOpacity(0.8),
                          ),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (item.brandName != null)
                                Text(
                                  item.brandName!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Ordered on',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                widget.order.formattedOrderDate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.order.status,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                        color: TColors.secondary,
                        fontWeightDelta: 1,
                      ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => OrderOtpScreen(order: widget.order));
                    }, // Navigate to OTP screen
                    child: Row(
                      children: [
                        Icon(Iconsax.key, size: 18, color: TColors.accent),
                        const SizedBox(width: 12),
                        Text(
                          'OTP',
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: TColors.accent,
                              ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      CartController.instance.repeatOrder(widget.order);
                      Get.to(() => const CheckOutScreen());
                    },
                    child: Row(
                      children: [
                        Icon(Iconsax.refresh, size: 18, color: TColors.accent),
                        const SizedBox(width: 12),
                        Text(
                          'Repeat Order',
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: TColors.accent,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}