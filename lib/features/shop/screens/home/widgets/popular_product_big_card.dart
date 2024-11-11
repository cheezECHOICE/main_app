import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/favourite_button.dart';
import 'package:cheezechoice/features/shop/models/product_model.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/add_to_cart_button.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/shimmer_image.dart';

class PopularProductBigCard extends StatelessWidget {
  final ProductModel productModel;

  const PopularProductBigCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: ShimmerImage(
                  imageUrl: productModel.thumbnail,
                  height: 120,
                  width: double.infinity,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: FavouriteButton(
                  prodId: productModel.id,
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productModel.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      productModel.brand.toString() == 'null'
                          ? 'StoreName'
                          : productModel.brand.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${productModel.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    AddToCartButton(
                      product: productModel,
                      fontColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
