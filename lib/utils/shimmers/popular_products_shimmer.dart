import 'package:flutter/material.dart';
import 'package:food/utils/shimmers/shimmer.dart';

class TPopularProductsShimmer extends StatelessWidget {
  const TPopularProductsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      // only 4 shimmer cards
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: const TShimmerEffect(
                      height: 110,
                      width: double.infinity,
                      radius: 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TShimmerEffect(
                      height: 16,
                      width: 100,
                      radius: 4,
                    ),
                    const SizedBox(height: 8),
                    const TShimmerEffect(
                      height: 14,
                      width: 50,
                      radius: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TShimmerEffect(
                          height: 16,
                          width: 40,
                          radius: 4,
                        ),
                        const TShimmerEffect(
                          height: 30,
                          width: 30,
                          radius: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
