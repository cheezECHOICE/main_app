import 'package:cheezechoice/features/shop/screens/home/widgets/exclusive_card.dart';
import 'package:flutter/material.dart';
import 'package:cheezechoice/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/home_categories.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/popular_products.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/search_container.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/title_divider.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  // Appbar
                  THomeAppBar(),

                  // SearchBar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchContainer(),
                  ),
                  SizedBox(height: 0.5 * TSizes.spaceBtwSections),

                  PromoSlider(),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            // Categories
            const SizedBox(height: TSizes.spaceBtwInputFields),
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
              child: Column(
                children: [
                  TitleDivider(title: 'Categories'),
                  SizedBox(height: TSizes.spaceBtwItems - 2),

                  // Categories
                  THomeCategories(),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems * 2 - 2),

            // divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Divider(
                thickness: 0.2,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems - 12),

            // Exclusive Store card
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: const Text(
                          'Exclusive Stores',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('View All pressed');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems - 4),

                  // Exclusive Card
                  ExclusiveCard(
                    imagePath: 'assets/exclusive.webp',
                    onPressed: () {
                      print('Exclusive Card Pressed');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems + 4),

            // Popular Products
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                children: [
                  TitleDivider(title: 'Popular Items'),
                  SizedBox(height: TSizes.spaceBtwItems),
                  PopularProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
