import 'package:flutter/material.dart';
import 'package:food/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:food/features/shop/models/cart_item_model.dart';
import 'package:food/features/shop/screens/store/widgets/shimmer_image.dart';
//import 'package:food/utils/constants/image_strings.dart';
import 'package:food/utils/constants/sizes.dart';

import '../../texts/product_title_text.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///Image
        ClipOval(
          child: ShimmerImage(
            imageUrl: cartItem.image ?? '',
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        ///Title,Price and Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBrandTitleWithVerifiedIcon(title: cartItem.brandName ?? ''),
              Flexible(
                  child: TProductTitleText(title: cartItem.title, maxLines: 1)),

              ///Attributes
              Text.rich(
                TextSpan(
                  children: (cartItem.selectedVariation ?? {})
                      .entries
                      .map(
                        (e) => TextSpan(
                          children: [
                            TextSpan(
                                text: ' ${e.key} ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                                text: ' ${e.value} ',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}