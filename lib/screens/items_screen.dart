import 'package:EcoEats/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:EcoEats/screens/loading_screen.dart';
import 'package:EcoEats/screens/alternatives_screen.dart';
import 'package:EcoEats/screens/recipe_screen.dart';
import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/widgets/item_tile.dart';

import '../services/api_service.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _addItem(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<FoodItemProvider>().addItem(text);
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<FoodItemProvider>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Items"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Items list
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(4),
                  child: Consumer<FoodItemProvider>(
                    builder: (context, provider, _) {
                      final items = provider.items;
                      return items.isEmpty
                          ? const Center(child: Text('No items added yet'))
                          : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ItemTile(
                            item: items[index],
                            onRemove: () => provider.removeItem(index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add item input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Add an item!',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addItem(context),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addItem(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Bottom submit buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 28),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeScreen()),
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: () => _showBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Submit"),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Generate Alternatives'),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LoadingScreen(
                  message: "Finding alternatives...",
                  animationAsset: 'lib/assets/animations/generate_alternatives.gif',
                  isGif: true,
                  onComplete: (context) async {
                    final foodItems = context.read<FoodItemProvider>().items;
                    final altProvider = Provider.of<AlternativesProvider>(context, listen: false);

                    final result = await ApiService.fetchAlternatives(context, foodItems);
                    print("Result: ");
                    print(result);
                    if (result != null) {
                      for (String item in foodItems) {
                        altProvider.setAlternativesForFood(item, result[item] ?? []);
                      }

                      Navigator.of(context).pop(); // Close loading screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AlternativesScreen(),
                      ));
                    } else {
                      Navigator.of(context).pop(); // Close loading screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to fetch alternatives")),
                      );
                    }
                    // altProvider.setAlternativesForFood("Chicken", [
                    //   Alternative(
                    //     name: "Tofu",
                    //     justification: "Plant-based protein with much lower emissions",
                    //     co2: 1.2,
                    //     category: "Proteins",
                    //   ),
                    //   Alternative(
                    //     name: "Lentils",
                    //     justification: "High protein and very low carbon footprint",
                    //     co2: 0.9,
                    //     category: "Proteins",
                    //   ),
                    //   Alternative(
                    //     name: "Tempeh",
                    //     justification: "Fermented soy product, nutritious and eco-friendly",
                    //     co2: 1.1,
                    //     category: "Proteins",
                    //   ),
                    //   Alternative(
                    //     name: "Seitan",
                    //     justification: "Wheat gluten-based protein alternative",
                    //     co2: 1.0,
                    //     category: "Proteins",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Vegetables",
                    //   ),
                    // ]);
                    // altProvider.setAlternativesForFood("Doritos", [
                    //   Alternative(
                    //     name: "Tofu",
                    //     justification: "Plant-based protein with much lower emissions",
                    //     co2: 1.2,
                    //     category: "Vegetables",
                    //   ),
                    //   Alternative(
                    //     name: "Lentils",
                    //     justification: "High protein and very low carbon footprint",
                    //     co2: 0.9,
                    //     category: "Fruits",
                    //   ),
                    //   Alternative(
                    //     name: "Tempeh",
                    //     justification: "Fermented soy product, nutritious and eco-friendly",
                    //     co2: 1.1,
                    //     category: "Grains",
                    //   ),
                    //   Alternative(
                    //     name: "Seitan",
                    //     justification: "Wheat gluten-based protein alternative",
                    //     co2: 1.0,
                    //     category: "Proteins",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Dairy",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Seafood",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Sweets",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Beverages",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Snacks",
                    //   ),
                    //   Alternative(
                    //     name: "Mushrooms",
                    //     justification: "Rich in nutrients and low in emissions",
                    //     co2: 0.8,
                    //     category: "Other",
                    //   ),
                    // ]);
                  },
                ),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Generate Recipe'),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LoadingScreen(
                  message: "Generating recipe...",
                  animationAsset: 'lib/assets/animations/generate_recipes.gif',
                  isGif: true,
                  onComplete: (context) async {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RecipeScreen(
                        dishName: "Miso Soup",
                        base64Image: "",
                        ingredients: ["dashi", "stock", "hot water", "miso", "firm tofu", "green onion"],
                        steps: [
                          "Transfer dashi to a small soup pot over medium-low heat.",
                          "Meanwhile, stir together hot water and miso until miso is dissolved.",
                          "Pour watery miso mixture into the pot.",
                          "Add cubed tofu.",
                          "Bring the pot to a simmer.",
                          "To serve, sprinkle sliced green onions and a pinch of katsuobushi on top.",
                        ],
                      ),
                    ));
                  },
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
