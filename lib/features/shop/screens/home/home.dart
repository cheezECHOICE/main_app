import 'package:cheezechoice/launching.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cheezechoice/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:cheezechoice/features/pickup/screens/handoff.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/home_categories.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/popular_products.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/search_container.dart';
import 'package:cheezechoice/features/shop/screens/home/widgets/title_divider.dart';
import 'package:cheezechoice/utils/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isLoading = false.obs;
    return Scaffold(
      body: Obx(() {
        return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const TPrimaryHeaderContainer(
                      child: Column(
                        children: [
                          THomeAppBar(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: SearchContainer(),
                          ),
                          SizedBox(height: 0.5 * TSizes.spaceBtwSections),
                          PromoSlider(),
                          SizedBox(height: TSizes.spaceBtwSections),
                        ],
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _buildCard(
                              'Sweets & Desserts',
                              'Everyday up to 10% off',
                              [Colors.pink.shade200, Colors.orange.shade200],
                              isLarge: true,
                              showOrderButton: true,
                              onOrderNow: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LaunchingSoonPage()));
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildCard(
                                  'HandOff',
                                  'Pick-&-Drop your favourite fast food',
                                  [Colors.purple.shade200, Colors.blue.shade300],
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LaunchingSoonPage()));
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildCard(
                                  'Exclusive',
                                  'Grocery & more..',
                                  [Colors.green.shade200, Colors.teal.shade300],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems + 4),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
                      child: Column(
                        children: [
                          TitleDivider(title: 'Categories'),
                          SizedBox(height: TSizes.spaceBtwItems - 2),
                          THomeCategories(),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems * 2 - 2),

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
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildCard(
    String title,
    String subtitle,
    List<Color> gradientColors, {
    bool isLarge = false,
    bool showOrderButton = false,
    VoidCallback? onTap,
    VoidCallback? onOrderNow,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isLarge ? 150 : 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              if (showOrderButton)
                Positioned(
                  right: 0,
                  bottom: 5,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: onOrderNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
