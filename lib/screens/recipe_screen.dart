import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generated Recipe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image placeholder
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(child: Text("[Recipe Image]")),
            ),
            const SizedBox(height: 16),
            const Text(
              "1. Mix all ingredients\n2. Cook for 20 minutes\n3. Serve hot",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}