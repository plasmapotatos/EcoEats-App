import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/widgets/food_group_slider.dart';
import 'package:EcoEats/widgets/alternative_tile.dart';
import 'package:EcoEats/widgets/food_selector_slider.dart';

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
  bool sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.read<FoodItemProvider>();
    final altProvider = context.watch<AlternativesProvider>();

    final foods = foodProvider.items;
    final currentFood = foods[selectedFoodIndex];

    final baseGroups = altProvider.getFoodGroups(currentFood);
    final groups = ["All", for (final name in foodGroupOrder)
        if (baseGroups.contains(name)) name
    ];

    final group = selectedGroup ?? "All";
    List<Alternative> filteredAlts = group == "All"
        ? altProvider.getAlternatives(currentFood)
        : altProvider.getByGroup(currentFood, group);

    filteredAlts.sort((a, b) =>
    sortAscending ? a.co2.compareTo(b.co2) : b.co2.compareTo(a.co2));


    return Scaffold(
      appBar: AppBar(title: const Text("Alternatives")),
      body: Column(
        children: [
          // Horizontal food selection
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
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
          ),
          const SizedBox(height: 12),

          // Food group image slider
          FoodGroupSlider(
            groups: groups,
            selected: group ?? "",
            onSelect: (g) => setState(() => selectedGroup = g),
          ),

          // TODO: the below is a sort button for co2, TBD if this is necessary
          // const SizedBox(height: 12),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       IconButton(
          //         onPressed: () {
          //           setState(() {
          //             sortAscending = !sortAscending;
          //           });
          //         },
          //         icon: Icon(
          //           sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          //           color: Colors.blueGrey,
          //         ),
          //         tooltip: sortAscending ? 'Sort by lowest CO₂' : 'Sort by highest CO₂',
          //       ),
          //     ],
          //   ),
          // ),

          // Alternatives list
          Expanded(
            child: ListView.builder(
              itemCount: filteredAlts.length,
              itemBuilder: (context, index) =>
                  AlternativeTile(alt: filteredAlts[index]),
            ),
          ),
        ],
      ),
    );
  }
}
