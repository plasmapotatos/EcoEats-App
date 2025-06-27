import 'dart:convert';
import 'package:EcoEats/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:EcoEats/widgets/touch_up_modal.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../services/api_service.dart';
import 'loading_screen.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  void _showTouchUpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return TouchUpModal(
          onSubmit: (feedback) async {
            final recipeProvider = context.read<RecipeProvider>();
            final recipe = recipeProvider.recipe;
            if (recipe == null) return;

            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LoadingScreen(
                message: "Improving your recipe...",
                animationAsset: 'lib/assets/animations/generate_recipes.gif',
                isGif: true,
                onComplete: (context) async {
                  final updated = await ApiService.generateRecipe(
                    context,
                    ingredientsText: recipe.ingredients.join(", "),
                    previousRecipe: recipe,
                    preferences: feedback,
                  );
                  Navigator.of(context).pop(); // Close loading
                  if (updated != null) {
                    recipeProvider.setRecipe(updated);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to improve recipe")),
                    );
                  }
                },
              ),
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = context.watch<RecipeProvider>().recipe;

    if (recipe == null) {
      return const Scaffold(
        body: Center(child: Text("No recipe available.")),
      );
    }

    final decodedImage = recipe.imageBase64.isEmpty
        ? null
        : base64Decode(recipe.imageBase64);

    return Scaffold(
      backgroundColor: EcoEatsTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Generated Recipe",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: EcoEatsTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  // Scrollable Title
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: false,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Touch Up Button
                  ElevatedButton.icon(
                    onPressed: () => _showTouchUpModal(context),
                    icon: const Icon(Icons.edit_note, color: Colors.black),
                    label: const Text("Touch Up", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EcoEatsTheme.tertiaryBackground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),



              const SizedBox(height: 16),

              // Image
              Container(
                decoration: BoxDecoration(
                  color: EcoEatsTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: decodedImage != null
                      ? Image.memory(decodedImage, height: 200, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Center(child: Text('No Image Available', style: TextStyle(color: Colors.black54))),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ingredients
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EcoEatsTheme.tertiaryBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: EcoEatsTheme.secondaryBackground)),
                    const SizedBox(height: 8),
                    ...recipe.ingredients.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 16)),
                          Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Steps
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: EcoEatsTheme.tertiaryBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Steps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: EcoEatsTheme.secondaryBackground)),
                    const SizedBox(height: 8),
                    ...recipe.steps.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("${entry.key + 1}. ${entry.value}", style: const TextStyle(fontSize: 16)),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}