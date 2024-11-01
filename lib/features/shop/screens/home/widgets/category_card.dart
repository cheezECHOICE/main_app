import 'package:flutter/material.dart';
import 'package:food/features/shop/controllers/category_controller.dart';
import 'package:food/features/shop/models/category_model.dart';
import 'package:food/features/shop/screens/home/widgets/category_products.dart';
import 'package:food/utils/shimmers/shimmer.dart';
import 'package:get/get.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryCard({Key? key, required this.categoryModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 100),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              CategoryController.instance.setCategory(categoryModel);
              Get.to(() => const CategoryProductsScreen());
            },
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: categoryModel.image.isNotEmpty
                    ? Image.network(
                        categoryModel.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return TShimmerEffect(width: 75, height: 75);
                          }
                        },
                      )
                    : TShimmerEffect(width: 75, height: 75),
              ),
            ),
          ),
          SizedBox(height: 4),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                categoryModel.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
