import 'package:EcoEats/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:EcoEats/screens/loading_screen.dart';
import 'package:EcoEats/screens/alternatives_screen.dart';
import 'package:EcoEats/screens/recipe_screen.dart';
import 'package:EcoEats/providers/alternatives_provider.dart';
import 'package:EcoEats/widgets/item_tile.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../services/api_service.dart';

const bool useMockData = false;

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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<FoodItemProvider>().items;

    return Scaffold(
      backgroundColor: const Color(0xFFFF9E1B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Your items",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[ // This fixes the children list error
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B511E),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(items[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            GestureDetector(
                              onTap: () => context
                                  .read<FoodItemProvider>()
                                  .removeItem(index),
                              child: const Icon(Icons.close,
                                  color: Color(0xFF2B511E)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'kale',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addItem(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _addItem(context),
                    child: const Icon(Icons.add_circle,
                        color: Color(0xFF2B511E)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const HomeScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B511E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _showBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B511E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Scan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 2)
                        ])),
                Text("Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 2)
                        ])),
              ],
            ),
            const SizedBox(height: 16),
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
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // adds breathing room
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text(
                'Generate Alternatives',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LoadingScreen(
                    message: "Finding alternatives...",
                    animationAsset: 'lib/assets/animations/generate_alternatives.gif',
                    isGif: true,
                    onComplete: (context) async {
                      final foodItems = Provider.of<FoodItemProvider>(context, listen: false);
                      final altProvider = Provider.of<AlternativesProvider>(context, listen: false);
                      if (useMockData) {
                        altProvider.setAlternativesForFood("Chicken", [
                          Alternative(
                            name: "Tofu",
                            justification: "Plant-based protein with much lower emissions",
                            co2: 1.2,
                            category: "Proteins",
                          ),
                          Alternative(
                            name: "Lentils",
                            justification: "High protein and very low carbon footprint",
                            co2: 0.9,
                            category: "Proteins",
                          ),
                          Alternative(
                            name: "Tempeh",
                            justification: "Fermented soy product, nutritious and eco-friendly",
                            co2: 1.1,
                            category: "Proteins",
                          ),
                          Alternative(
                            name: "Seitan",
                            justification: "Wheat gluten-based protein alternative",
                            co2: 1.0,
                            category: "Proteins",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Vegetables",
                          ),
                        ]);
                        altProvider.setAlternativesForFood("Doritos", [
                          Alternative(
                            name: "Tofu",
                            justification: "Plant-based protein with much lower emissions",
                            co2: 1.2,
                            category: "Vegetables",
                          ),
                          Alternative(
                            name: "Lentils",
                            justification: "High protein and very low carbon footprint",
                            co2: 0.9,
                            category: "Fruits",
                          ),
                          Alternative(
                            name: "Tempeh",
                            justification: "Fermented soy product, nutritious and eco-friendly",
                            co2: 1.1,
                            category: "Grains",
                          ),
                          Alternative(
                            name: "Seitan",
                            justification: "Wheat gluten-based protein alternative",
                            co2: 1.0,
                            category: "Proteins",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Dairy",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Seafood",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Sweets",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Beverages",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Snacks",
                          ),
                          Alternative(
                            name: "Mushrooms",
                            justification: "Rich in nutrients and low in emissions",
                            co2: 0.8,
                            category: "Other",
                          ),
                        ]);
                      } else {
                        print("Fetching alternatives");
                        final result = await ApiService.fetchAlternatives(
                            context, foodItems.items);
                        print("Result: ");
                        print(result);
                        if (result != null) {
                          for (String item in foodItems.items) {
                            altProvider.setAlternativesForFood(
                                item, result[item] ?? []);
                          }
                        }
                      }



                      Navigator.of(context).pop(); // Close loading screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AlternativesScreen(),
                      ));
                    },
                  ),
                ));
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text(
                'Generate Recipe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LoadingScreen(
                    message: "Generating recipe...",
                    animationAsset: 'lib/assets/animations/generate_recipes.gif',
                    isGif: true,
                    onComplete: (context) async {
                      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

                      if (useMockData) {
                        recipeProvider.setRecipe(
                          Recipe(
                            title: "Miso Soup",
                            imageBase64: "", // No image in mock
                            ingredients: [
                              "dashi",
                              "stock",
                              "hot water",
                              "miso",
                              "firm tofu",
                              "green onion"
                            ],
                            steps: [
                              "Transfer dashi to a small soup pot over medium-low heat.",
                              "Meanwhile, stir together hot water and miso until miso is dissolved.",
                              "Pour watery miso mixture into the pot.",
                              "Add cubed tofu.",
                              "Bring the pot to a simmer.",
                              "To serve, sprinkle sliced green onions and a pinch of katsuobushi on top."
                            ],
                          ),
                        );
                      } else {
                        final ingredients = context.read<FoodItemProvider>().items.join(", ");
                        final recipe = await ApiService.generateRecipe(
                          context,
                          ingredientsText: ingredients,
                        );

                        if (recipe == null) {
                          Navigator.of(context).pop(); // Close loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to generate recipe")),
                          );
                          return;
                        }

                        recipeProvider.setRecipe(recipe);
                      }

                      Navigator.of(context).pop(); // Close loading screen
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RecipeScreen()),
                      );
                    },
                  ),
                ));
              },
            ),
          ],
        ),
      )
    );
  }
}
