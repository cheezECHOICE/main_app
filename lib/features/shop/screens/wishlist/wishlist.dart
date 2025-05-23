import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/appbar/appbar.dart';
import 'package:cheezechoice/common/widgets/layouts/gird_layout.dart';
import 'package:cheezechoice/common/widgets/loaders/animation_loader.dart';
import 'package:cheezechoice/common/widgets/products/prodect_cards/product_card_vertical.dart';
import 'package:cheezechoice/features/shop/controllers/product/favourite_controller.dart';
import 'package:cheezechoice/navigation_menu.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:cheezechoice/utils/helpers/cloud_helper_function.dart';
import 'package:cheezechoice/utils/shimmers/popular_products_shimmer.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title:
            Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Obx(
              () => FutureBuilder(
                  future: controller.favouriteProducts(),
                  builder: (context, snapshot) {
                    // Nothing found widget
                    final emptyWidget = TAnimationLoaderWidget(
                        text: 'Whoops! Your WishList is empty..',
                        animation: TImages.daceranimation,
                        // Add animation image LATERrrrr
                        showAction: true,
                        actionText: 'Let\'s add some',
                        onActionPressed: () {
                          Navigator.of(Get.context!).pop();
                          NavigationController.instance.selectedIndex.value = 0;
                        });
                    const loader = TPopularProductsShimmer();
                    final widget = TCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot,
                        loader: loader,
                        nothingFound: emptyWidget);
                    if (widget != null) return widget;
                    final products = snapshot.data!;
                    return TGirdLayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) =>
                            TProductCardVertical(product: products[index]));
                  }),
            )
            //],
            ),
      ),
    );
    //);
  }
}
