import 'package:flutter/material.dart';
import 'package:food/features/shop/screens/search/search_screen.dart';
import 'package:food/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => const SearchScreen(), transition: Transition.downToUp),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: THelperFunctions.isDarkMode(context)
              ? Colors.black.withOpacity(0.6)
              : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                ),
                SizedBox(width: 8),
                Text(
                  'Search for products',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
