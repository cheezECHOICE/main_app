import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import 'package:food/common/widgets/images/t_rounded_images.dart';
import 'package:food/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:food/features/shop/controllers/product/images_controller.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = Get.put(ImageController());
    final images = controller.getAllProductImages(product);
    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            ///Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(
                  child: Obx(
                    () {
                      final image = controller.selectedProductImage.value;
                      return GestureDetector(
                        onTap: () => controller.showEnlargedImage(image),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          progressIndicatorBuilder: (_, __, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: TColors.primary),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            ///Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: TSizes.spaceBtwItems),
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) => Obx(() {
                    final imageSelected =
                        controller.selectedProductImage.value == images[index];
                    return TRoundedImage(
                      width: 80,
                      isNetworkImage: true,
                      backgroundColor: dark ? TColors.dark : TColors.white,
                      onPressed: () =>
                          controller.selectedProductImage.value = images[index],
                      border: Border.all(
                          color: imageSelected
                              ? TColors.primary
                              : Colors.transparent),
                      padding: const EdgeInsets.all(TSizes.sm),
                      imageUrl: images[index],
                    );
                  }),
                ),
              ),
            ),

            /// AppBar Icons
            TAppBar(
              showBackArrow: true,
              actions: [TFavouriteIcon(productId: product.id)],
            )
          ],
        ),
      ),
    );
  }
}
