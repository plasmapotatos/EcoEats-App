import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:EcoEats/theme/food_group_icons.dart';
import 'package:EcoEats/theme/theme.dart';

class FoodGroupSlider extends StatelessWidget {
  final List<String> groups;
  final String selected;
  final Function(String) onSelect;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;

  const FoodGroupSlider({super.key,
    required this.groups,
    required this.selected,
    required this.onSelect,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          final icon = foodGroupIcons[group] ?? FontAwesomeIcons.utensils;

          return GestureDetector(
            onTap: () => onSelect(group),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                    selected == group ? EcoEatsTheme.selectedBackground : EcoEatsTheme.unselectedBackground,
                    child: Icon(
                      icon,
                      size: 20,
                      color: selected == group ? EcoEatsTheme.selectedText : EcoEatsTheme.unselectedText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected == group ? EcoEatsTheme.selectedBackground : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}