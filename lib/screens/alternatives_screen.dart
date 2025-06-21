import 'package:flutter/material.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:provider/provider.dart';

class AlternativesScreen extends StatefulWidget {
  const AlternativesScreen({super.key});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final foods = context.watch<FoodItemProvider>().items;

    return Scaffold(
      appBar: AppBar(title: const Text("Alternatives")),
      body: Column(
        children: [
          // Horizontal food selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedIndex == index
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Text(
                      foods[index],
                      style: TextStyle(
                        color:
                        selectedIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Placeholder alternatives list
          Expanded(
            child: ListView.builder(
              itemCount: 5, // mock 5 alternatives
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.eco_outlined),
                title: Text("Alternative ${index + 1} for ${foods[selectedIndex]}"),
                subtitle: const Text("-0.2 kg CO2-eq/kg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}