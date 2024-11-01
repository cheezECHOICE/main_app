import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/products/ratings/rating_indicator.dart';
import 'package:food/features/shop/screens/product_reviews/widgets/overapp_product_rating.dart';
import 'package:food/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:food/utils/constants/sizes.dart';

class ProductReviewScreen extends StatelessWidget {
  const ProductReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- Appbar
      appBar:
          const TAppBar(title: Text('Reviews & Ratings'), showBackArrow: true),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Ratings and reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Overall Product Ratings
              const OverAllProductRatings(),
              const TRatingBarIndicator(
                rating: 4.7,
              ),
              Text("12,611", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: TSizes.spaceBtwSections),

              // User Review List
              const UserReviewCard(),
              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
