import 'package:flutter/material.dart';
import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:provider/provider.dart';

class AlternativeTile extends StatelessWidget {
  final Alternative alt;

  const AlternativeTile({super.key, required this.alt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final foodProvider = Provider.of<FoodItemProvider>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: name + category + co2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(alt.name, style: theme.titleMedium),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alt.category,
                          style: theme.labelMedium?.copyWith(
                            color: Colors.green.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${alt.co2.toStringAsFixed(2)} kg CO₂-eq/kg",
                      style: theme.labelMedium?.copyWith(color: Colors.grey.shade700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: "Add to item list",
                      onPressed: () {
                        foodProvider.addItem(alt.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${alt.name} successfully added to your items!"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(alt.justification, style: theme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
