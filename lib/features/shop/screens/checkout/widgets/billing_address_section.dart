import 'package:flutter/material.dart';
import 'package:food/common/widgets/texts/section_heading.dart';
import 'package:food/features/personalisation/controllers/address_controller.dart';
import 'package:food/utils/constants/sizes.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
            title: 'Shipping Address',
            buttonTitle: 'Change',
            onPressed: () => addressController.selectNewAddressPopup(context)),
        addressController.selectedAddress.value.id.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Venu Charan',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Text('+91 7854621965',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_history,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                          child: Text(
                              'SVS Nagar, Mylavaram,NTR Dist, AndhraPradesh',
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                ],
              )
            : Text('Select Address',
                style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
