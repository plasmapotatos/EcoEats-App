import 'package:flutter/material.dart';

import '../theme/theme.dart';

class FoodSelectorSlider extends StatelessWidget {
  final List<String> foods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FoodSelectorSlider({
    super.key,
    required this.foods,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isSelected
                    ? EcoEatsTheme.selectedBackground : EcoEatsTheme.unselectedBackground,
              ),
              child: Center(
                child: Text(
                  foods[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}