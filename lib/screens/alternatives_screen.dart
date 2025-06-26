import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/widgets/food_group_slider.dart';
import 'package:EcoEats/widgets/alternative_tile.dart';

class AlternativesScreen extends StatefulWidget {
  const AlternativesScreen({super.key});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

const List<String> foodGroupOrder = [
  "All",
  "Vegetables",
  "Fruits",
  "Grains",
  "Proteins",
  "Dairy",
  "Seafood",
  "Sweets",
  "Beverages",
  "Snacks",
  "Other",
];

class _AlternativesScreenState extends State<AlternativesScreen> {
  int selectedFoodIndex = 0;
  String? selectedGroup;

  final Color orange = const Color(0xFFF7931E);
  final Color darkGreen = const Color(0xFF2E5623);

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.read<FoodItemProvider>();
    final altProvider = context.watch<AlternativesProvider>();

    final foods = foodProvider.items;
    final currentFood = foods[selectedFoodIndex];

    final baseGroups = altProvider.getFoodGroups(currentFood);
    final groups = ["All", for (final name in foodGroupOrder) if (baseGroups.contains(name)) name];

    final group = selectedGroup ?? "All";
    final filteredAlts = group == "All"
        ? altProvider.getAlternatives(currentFood)
        : altProvider.getByGroup(currentFood, group);

    return Scaffold(
      backgroundColor: orange,
      appBar: AppBar(
        title: const Text(
          "Alternatives",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: orange,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Styled Title
            const SizedBox(height: 8),

            // Food Selector
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedFoodIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFoodIndex = index;
                        selectedGroup = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected ? darkGreen : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          foods[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Food Group Slider
            FoodGroupSlider(
              groups: groups,
              selected: group,
              onSelect: (g) => setState(() => selectedGroup = g),
              backgroundColor: darkGreen,
              selectedColor: Colors.white,
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),

            // Alternatives List inside dark green rounded container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: ListView.builder(
                  itemCount: filteredAlts.length,
                  itemBuilder: (context, index) {
                    final alt = filteredAlts[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal:15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with name, group, and plus button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Name and group on the left
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        alt.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: darkGreen.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        alt.group,
                                        style: TextStyle(
                                          color: darkGreen,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Plus icon on the right
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: darkGreen,
                                tooltip: 'Add',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${alt.name} added!')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Description line
                          Text(
                            alt.description ?? "Rich in nutrients and low in emissions",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // CO2 line
                          Row(
                            children: [
                              const Icon(Icons.eco, size: 16, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                "${alt.co2.toStringAsFixed(2)} kg CO₂-eq/kg",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
