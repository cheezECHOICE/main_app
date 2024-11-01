import 'package:flutter/material.dart';
import 'package:food/common/widgets/layouts/gird_layout.dart';
import 'package:food/common/widgets/products/prodect_cards/product_card_vertical.dart';
import 'package:food/features/shop/controllers/all_products_controller.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);
    return Column(
      children: [
        ///DropDown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOptions.value,
          onChanged: (value) {
            // Sort Products based on the selected option
            controller.sortProducts(value!);
          },
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Popularity',
            'Newest',
            'Sale'
          ]
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        Obx(() => TGirdLayout(
            itemCount: controller.products.length,
            itemBuilder: (_, index) =>
                TProductCardVertical(product: controller.products[index]))),
      ],
    );
  }
}
