import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/dotted_divider.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';
import 'package:cheezechoice/utils/shimmers/shimmer.dart';

class TBrandProductsShimmer extends StatelessWidget {
  const TBrandProductsShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < itemCount; i++)
          Column(
            children: [
              TShimmerEffect(
                height: 160,
                width: THelperFunctions.screenWidth() * 0.85,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: DottedDivider(),
              ),
            ],
          ),
      ],
    );
  }
}
