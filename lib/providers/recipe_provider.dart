import 'package:flutter/material.dart';
import 'package:EcoEats/models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  Recipe? _recipe;

  Recipe? get recipe => _recipe;

  void setRecipe(Recipe recipe) {
    _recipe = recipe;
    notifyListeners();
  }

  void clearRecipe() {
    _recipe = null;
    notifyListeners();
  }
}
