import 'package:flutter/material.dart';
import 'package:cheezechoice/features/shop/models/product_model.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/product_details_page.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/add_to_cart_button.dart';
import 'package:cheezechoice/features/shop/screens/store/widgets/shimmer_image.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool showBrandName;

  const ProductCard({
    super.key,
    required this.product,
    this.showBrandName = true,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the product is out of stock
    final bool isOutOfStock =
        product.stock < 5; // Assuming stock is an integer field in ProductModel

    return InkWell(
      onTap: () {
        if (!isOutOfStock) {
          showProductDetailBottomSheet(context, product);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 160,
        decoration: BoxDecoration(
          //color: isOutOfStock ? Colors.black : Colors.white, // Set background color based on stock
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.description ?? 'No description found.',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isOutOfStock) // Show 'Out of Stock' message if stock is 0
                      Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.red,
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (!isOutOfStock) // Show AddToCartButton only if in stock
                      AddToCartButton(product: product),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ShimmerImage(
                    height: 150,
                    width: THelperFunctions.screenWidth() * 0.4,
                    imageUrl: product.thumbnail,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '₹${product.price.toString()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (showBrandName && product.brand != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        product.brand!.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
