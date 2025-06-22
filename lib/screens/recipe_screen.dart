import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:EcoEats/widgets/touch_up_modal.dart';

class RecipeScreen extends StatelessWidget {
  final String dishName;
  final List<String> ingredients;
  final List<String> steps;
  final String base64Image;

  const RecipeScreen({
    super.key,
    required this.dishName,
    required this.ingredients,
    required this.steps,
    required this.base64Image,
  });

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
            // TODO: Send feedback to backend
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
    final decodedImage = base64Image == "" ? null : base64Decode(base64Image);

    return Scaffold(
      appBar: AppBar(title: const Text("Generated Recipe")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: decodedImage != null
                ? Image.memory(
                  decodedImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'No Image Available',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
              )
            ),
            const SizedBox(height: 16),

            // Dish name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    dishName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showTouchUpModal(context),
                  icon: const Icon(Icons.edit_note),
                  label: const Text("Touch Up Recipe"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),

            // Ingredients
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ingredients.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
                ],
              ),
            )),

            const SizedBox(height: 16),

            // Steps
            const Text(
              "Steps",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...steps.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "${entry.key + 1}. ${entry.value}",
                style: const TextStyle(fontSize: 16),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
