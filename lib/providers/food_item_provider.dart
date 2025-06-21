import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodItemProvider extends ChangeNotifier {
  List<String> _items = [];

  List<String> get items => _items;

  FoodItemProvider() {
    _loadItems();
  }

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
    _saveItems();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
    _saveItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('food_items') ?? [];
    _items = stored;
    notifyListeners();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('food_items', _items);
  }
}
