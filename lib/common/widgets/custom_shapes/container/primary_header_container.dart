import 'package:flutter/material.dart';
import 'package:food/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:food/common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import 'package:food/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -280,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(0.15))),
            Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(0.15))),
            Positioned(
                top: -150,
                left: -280,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(0.1))),
            child,
          ],
        ),
      ),
    );
  }
}
