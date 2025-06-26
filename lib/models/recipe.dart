class Recipe {
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final String imageBase64;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.imageBase64,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json["title"] ?? "Untitled Recipe",
      ingredients: List<String>.from(json["ingredients"] ?? []),
      steps: List<String>.from(json["steps"] ?? []),
      imageBase64: json["image_base64"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "ingredients": ingredients,
      "steps": steps,
      "image_base64": imageBase64,
    };
  }
}
