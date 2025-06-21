import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EcoEats/providers/food_item_provider.dart';
import 'package:EcoEats/screens/loading_screen.dart';
import 'package:EcoEats/screens/alternatives_screen.dart';
import 'package:EcoEats/screens/recipe_screen.dart';


class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _textController = TextEditingController();

  void _addItem(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<FoodItemProvider>().addItem(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<FoodItemProvider>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Items"),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Scrollbar(
                thumbVisibility: true, // Always show scrollbar
                thickness: 6,
                radius: const Radius.circular(4),
                child: Consumer<FoodItemProvider>(
                  builder: (context, provider, _) {
                    final items = provider.items;
                    return items.isEmpty
                        ? const Center(child: Text('No items added yet'))
                        : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => provider.removeItem(index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Add food item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(context),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addItem(context),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.check_circle, size: 30),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.swap_horiz),
                              title: const Text('Generate Alternatives'),
                              onTap: () async {
                                Navigator.pop(context); // close bottom sheet

                                // Navigate to loading screen, and wait for fake delay to simulate API call
                                await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => LoadingScreen(
                                    message: "Finding alternatives...",
                                    animationAsset: 'lib/assets/animations/generate_alternatives.gif', // Lottie file
                                    isGif: true,
                                    onComplete: (context) async {
                                      Navigator.of(context).pop(); // remove loading
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => AlternativesScreen(),
                                      ));
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
                                      Navigator.of(context).pop(); // remove loading
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => RecipeScreen(),
                                      ));
                                    },
                                  ),
                                ));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
