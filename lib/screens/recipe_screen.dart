import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:EcoEats/widgets/touch_up_modal.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';

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
          onSubmit: (feedback) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Submitted: \"$feedback\"")),
            );
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

    final Color orange = const Color(0xFFF7931E);
    final Color darkGreen = const Color(0xFF2E5623);

    return Scaffold(
      backgroundColor: orange,
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
            color: darkGreen,
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showTouchUpModal(context),
                    icon: const Icon(Icons.edit_note, color: Colors.white),
                    label: const Text("Touch Up", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
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
                  color: darkGreen,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen)),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Steps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen)),
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