import 'package:cheezechoice/data/repositories/order/order_repo.dart';
import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/styles/TRoundedContainer.dart';
import 'package:cheezechoice/features/shop/controllers/product/cart_controller.dart';
import 'package:cheezechoice/features/shop/models/order_model.dart';
import 'package:cheezechoice/features/shop/screens/checkout/checkout.dart';
import 'package:cheezechoice/features/shop/screens/orders/widgets/orders_otp.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
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
  bool _isBillingExpanded = false; // For billing details dropdown
  List<String> brandNames = []; // To hold the fetched brand names

  @override
  void initState() {
    super.initState();
    _fetchBrandNames();
  }

  Future<void> _fetchBrandNames() async {
    try {
      List<String> fetchedBrandNames = [];
      for (var item in widget.order.items) {
        String? brandName = await OrderRepository.instance
            .fetchBrandName(item.brandId.toString());
        if (brandName != null) {
          fetchedBrandNames.add(brandName);
        }
      }
      setState(() {
        brandNames = fetchedBrandNames;
      });
    } catch (e) {
      print("Error fetching brand names: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate billing details
    final double subtotal = widget.order.totalAmount;
    final double cgst =
        TPricingCalculator.getCGST(subtotal, widget.order.address);
    final double sgst =
        TPricingCalculator.getSGST(subtotal, widget.order.address);
    final double platformFee = 10.0; // Replace with actual calculation logic
    final double deliveryCharge = TPricingCalculator.getDeliveryForLocation(
        subtotal, widget.order.address);
    final double finalTotal =
        TPricingCalculator.finalTotalPrice(subtotal, widget.order.address);

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
              const Icon(Icons.fastfood_outlined, color: TColors.accent),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text("Order id: ",
                  style: Theme.of(context).textTheme.headlineSmall!.apply(
                        color: TColors.accent,
                      )),
              Text(
                widget.order.id,
                style: Theme.of(context).textTheme.headlineMedium!.apply(
                      color: TColors.accent,
                    ),
              ),
              const Spacer(),
              Text(
                '\Rs.${finalTotal}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: Colors.green.shade200),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              const Icon(Icons.food_bank_outlined),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              for (int i = 0; i < widget.order.items.length; i++)
                if (brandNames.isNotEmpty)
                  Text(
                    brandNames[i],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              const Icon(Icons.fmd_good_outlined),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text(
                widget.order.address,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => OrderOtpScreen(order: widget.order));
                },
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
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Divider(thickness: 1),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Items Dropdown
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items', style: Theme.of(context).textTheme.bodyLarge),
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
          SizedBox(height: 15),
          // Billing Details Dropdown
          // const Divider(thickness: 1),
          InkWell(
            onTap: () {
              setState(() {
                _isBillingExpanded = !_isBillingExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Billing Details',
                    style: Theme.of(context).textTheme.bodyLarge),
                Icon(
                  _isBillingExpanded
                      ? Iconsax.arrow_down_14
                      : Iconsax.arrow_right_3,
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: _isBillingExpanded ? 1 : 0,
              end: _isBillingExpanded ? 1 : 0,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBillingRow('Subtotal', subtotal),
                _buildBillingRow('CGST (2.5%)', cgst),
                _buildBillingRow('SGST (2.5%)', sgst),
                _buildBillingRow('Platform Fee', platformFee),
                _buildBillingRow('Delivery Charge', deliveryCharge),
                _buildBillingRow('Total', finalTotal),
              ],
            ),
          ),

          // Order Status and Repeat Order
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.order.status,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                        color: _getStatusColor(widget.order.status),
                        fontWeightDelta: 1,
                      ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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

  Widget _buildBillingRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text('Rs. ${value.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.brown; // Color for pending
      case 'ready':
        return Colors.orange; // Color for ready
      case 'cooking':
        return Colors.blue; // Color for cooking
      case 'delivered':
        return Colors.green; // Color for delivered
      default:
        return TColors.primary; // Default color
    }
  }
}
