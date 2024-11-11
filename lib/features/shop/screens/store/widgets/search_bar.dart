import 'package:flutter/material.dart';
import 'package:cheezechoice/utils/constants/colors.dart';
import 'package:cheezechoice/utils/helpers/helper_functions.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchHint;
  final Function filterFunction;
  final bool autoFocus;

  const MySearchBar({
    super.key,
    required this.searchController,
    required this.searchHint,
    required this.filterFunction,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: THelperFunctions.isDarkMode(context)
            ? TColors.primary.withOpacity(0.1)
            : TColors.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            autofocus: autoFocus,
            controller: searchController,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: TextStyle(
                color: THelperFunctions.isDarkMode(context)
                    ? Colors.grey[200]
                    : Colors.grey[600],
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              icon: const Icon(Icons.search, color: Colors.grey),
            ),
            onChanged: (value) {
              filterFunction(value);
            },
          ),
        ],
      ),
    );
  }
}
