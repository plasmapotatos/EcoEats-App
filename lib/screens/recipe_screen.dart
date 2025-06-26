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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
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
              // Top row: Dish name + edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      dishName,
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

              // 🟢 Image inside green container
              Container(
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Text(
                        'No Image Available',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🟠 Ingredients box (white)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
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
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🟠 Steps box (white)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Steps",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
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
            ],
          ),
        ),
      ),
    );
  }
}