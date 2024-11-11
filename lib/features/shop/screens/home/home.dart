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
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  //Appbar
                  THomeAppBar(),

                  //SearchBar
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

            //Categories
            SizedBox(height: TSizes.spaceBtwInputFields),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
              child: Column(
                children: [
                  TitleDivider(
                    title: 'Categories',
                  ),
                  SizedBox(height: TSizes.spaceBtwItems - 2),

                  //Categories
                  THomeCategories(),
                ],
              ),
            ),
            SizedBox(height: TSizes.spaceBtwItems),

            // Popular Products
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                children: [
                  TitleDivider(
                    title: 'Popular Items',
                  ),
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
