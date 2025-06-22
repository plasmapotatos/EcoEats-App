import 'package:flutter/material.dart';

class TouchUpModal extends StatelessWidget {
  final void Function(String feedback) onSubmit;

  const TouchUpModal({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Customize Your Recipe",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "E.g. I can't sauté, please make it boilable!",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              final feedback = controller.text.trim();
              if (feedback.isNotEmpty) {
                Navigator.pop(context);
                onSubmit(feedback);
              }
            },
            icon: const Icon(Icons.send),
            label: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
