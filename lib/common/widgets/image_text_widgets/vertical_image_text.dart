import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:food/utils/shimmers/shimmer.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    required this.title,
    this.textColor = TColors.white,
    this.backgroundColor,
    this.onTap,
    this.overlayColor,
    this.isNetworkImage = true,
  });

  final String image, title;
  final Color textColor;
  final BoxFit? fit;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(TSizes.iconMd),
              decoration: BoxDecoration(
                color: backgroundColor ??
                    (dark ? Colors.grey.shade200 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: isNetworkImage
                    ? CachedNetworkImage(
                        fit: fit,
                        color: overlayColor,
                        imageUrl: image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const TShimmerEffect(width: 55, height: 55),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image(
                        fit: fit,
                        image: AssetImage(image),
                        color: overlayColor,
                      ),
              ),
            ),

            ///Text
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            SizedBox(
              width: 60,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: dark ? Colors.white : Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
