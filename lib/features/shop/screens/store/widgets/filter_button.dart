import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterButton extends StatelessWidget {
  final Function() filterFunction;
  final RxBool isEnabled;
  final Color mainColor;
  final String label;

  const FilterButton({
    super.key,
    required this.filterFunction,
    required this.isEnabled,
    required this.mainColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: filterFunction,
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: Colors.transparent,
            end: isEnabled.value
                ? mainColor.withOpacity(0.4)
                : Colors.transparent,
          ),
          duration: const Duration(milliseconds: 150),
          builder: (context, color, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,
                border: Border.all(
                  color: mainColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: mainColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.circle,
                          color: mainColor,
                          size: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
