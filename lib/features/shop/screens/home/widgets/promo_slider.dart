import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/controllers/banner_controller.dart';
import 'package:cheezechoice/utils/shimmers/shimmer.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/container/circular_container.dart';
import '../../../../../common/widgets/images/t_rounded_images.dart';
import '../../../../../utils/constants/sizes.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(
      () {
        // Loader
        if (controller.isLoading.value) {
          return const TShimmerEffect(width: double.infinity, height: 190);
        }

        // No data found
        if (controller.banners.isEmpty) {
          return const Center(child: Text('No data found :('));
        } else {
          return Column(
            children: [
              CarouselSlider(
                  options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      onPageChanged: (index, _) =>
                          controller.updatePageIndicator(index)),
                  items: controller.banners
                      .map((banner) => TRoundedImage(
                            imageUrl: banner.imageUrl,
                            isNetworkImage: true,
                            // onPressed: (() => Get.toNamed(banner.targetScreen)),
                            padding: const EdgeInsets.all(5),
                          ))
                      .toList()),
              const SizedBox(height: TSizes.spaceBtwItems),
              // Center(
              //   child: Obx(
              //     () => Row(
              //       mainAxisSize: MainAxisSize.min,
              //       // children: [
              //       //   for (int i = 0; i < controller.banners.length; i++)
              //       //     TCircularContainer(
              //       //       width: 20,
              //       //       height: 4,
              //       //       margin: const EdgeInsets.only(right: 10),
              //       //       backgroundColor:
              //       //           controller.carousalCurrentIndex.value == i
              //       //               ? Colors.black
              //       //               : Colors.grey,
              //       //     ),
              //       // ],
              //     ),
              //   ),
              // )
            ],
          );
        }
      },
    );
  }
}
