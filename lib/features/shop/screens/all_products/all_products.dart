import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/common/widgets/appbar/appbar.dart';
import 'package:food/common/widgets/products/sortable/sortable_products.dart';
import 'package:food/features/shop/controllers/all_products_controller.dart';
import 'package:food/features/shop/models/product_model.dart';
import 'package:food/utils/constants/sizes.dart';
import 'package:food/utils/helpers/cloud_helper_function.dart';
import 'package:food/utils/shimmers/vertical_product_shimmer.dart';
import 'package:get/get.dart';

class AllProducts extends StatelessWidget {
  const AllProducts(
      {super.key, required this.title, this.query, this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    // Initialize controller for managing product fetching
    final controller = Get.put(AllProductsController());

    return Scaffold(
      appBar: TAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
              future: futureMethod ?? controller.fetchProductsByQuery(query),
              builder: (context, snapshot) {
                // Check the status of the FutureBuilder Snapshot
                const loader = TVerticalProductShimmer();
                final widget = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot, loader: loader);
                // Return appropiate widget based on snapshot state
                if (widget != null) return widget;

                // Products found
                final products = snapshot.data!;

                return TSortableProducts(products: products);
              }),
        ),
      ),
    );
  }
}
