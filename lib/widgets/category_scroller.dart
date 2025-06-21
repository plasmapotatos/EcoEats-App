import 'package:flutter/material.dart';

class CategoryScroller extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final PageController controller;
  final Function(int) onCategorySelected;

  const CategoryScroller({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.controller,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: controller,
        itemCount: categories.length,
        onPageChanged: onCategorySelected,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onCategorySelected(index),
          child: Center(
            child: Text(
              categories[index],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
