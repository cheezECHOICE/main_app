import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:food/features/personalisation/controllers/user_controller.dart';
import 'package:food/utils/constants/colors.dart';
import 'package:food/utils/constants/text_strings.dart';
import 'package:food/utils/shimmers/shimmer.dart';
import 'package:get/get.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimmerEffect(width: 80, height: 15);
            } else {
              return Text(controller.user.value.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: TColors.white));
            }
          }),
        ],
      ),
      actions: const [
        TWishlistCounterIcon(
            iconColor: TColors.white,
            counterBgColor: TColors.primary,
            counterTextColor: TColors.white),
      ],
    );
  }
}
