import 'package:flutter/material.dart';
import 'package:food/common/widgets/layouts/gird_layout.dart';
import 'package:food/utils/shimmers/shimmer.dart';

class TBrandsShimmer extends StatelessWidget {
  const TBrandsShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return TGirdLayout(
        mainAxisExtent: 80,
        itemCount: itemCount,
        itemBuilder: (_, __) => const TShimmerEffect(width: 300, height: 80));
  }
}
