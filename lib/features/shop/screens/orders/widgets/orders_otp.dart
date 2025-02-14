import 'package:cheezechoice/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
import 'package:cheezechoice/features/shop/controllers/product/order_controller.dart';
import 'package:cheezechoice/features/shop/models/order_model.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';

class OrderOtpScreen extends StatelessWidget {
  final OrderModel order;

  const OrderOtpScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Order OTP',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems),
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the card fits content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.id}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Total Amount: Rs.${TPricingCalculator.finalTotalPrice(order.totalAmount,order.address).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Ready at: ${order.formattedOrderDate}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Check if the order is in 'ready' status
                order.status == 'pickup'
                    ? FutureBuilder<String?>(
                        future: OrderController.instance.fetchOtp(
                            order.id, order.otp), // Use appropriate OTP
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show loading indicator while fetching OTP
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(color: Colors.red),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            return Text(
                              'OTP: ${snapshot.data}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .apply(color: TColors.accent),
                            );
                          } else {
                            return Text(
                              'No OTP available currently',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .apply(color: TColors.accent),
                            );
                          }
                        },
                      )
                    : Text(
                        'No OTP available currently',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.accent),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  // // Dummy OTP generator for now
  // String _generateDummyOtp() {
  //   return '123456'; // Replace with actual OTP logic
  // }
