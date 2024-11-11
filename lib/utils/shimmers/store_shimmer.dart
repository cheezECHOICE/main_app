import 'package:flutter/material.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/shimmers/shimmer.dart';

class TStoreShimmer extends StatelessWidget {
  const TStoreShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < itemCount; i++)
          Column(
            children: [
              TShimmerEffect(
                height: 230,
                width: THelperFunctions.screenWidth() * 0.85,
              ),
              const SizedBox(height: 1.25 * TSizes.spaceBtwItems),
            ],
          )
      ],
    );
  }
}
