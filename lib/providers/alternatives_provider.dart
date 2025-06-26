import 'package:flutter/foundation.dart';

class Alternative {
  final String name;
  final String justification;
  final double co2;
  final String category;
  final String group;
  final String? description;

  Alternative({
    required this.name,
    required this.justification,
    required this.co2,
    required this.category,
    this.group = "Other",
    this.description,
  });

  factory Alternative.fromJson(Map<String, dynamic> json) {
    return Alternative(
      name: json["Name"],
      justification: json["Justification"],
      co2: json["CO2"].toDouble(),
      category: json["Category"] ?? "Other",
      group: json["Group"] ?? "Other",
      description: json["Description"] ?? "Rich in nutrients and low in emissions",
    );
  }
}


class AlternativesProvider with ChangeNotifier {
  final Map<String, List<Alternative>> _data = {};

  void setAlternativesForFood(String foodName, List<Alternative> alternatives) {
    _data[foodName] = alternatives;
    notifyListeners();
  }

  List<Alternative> getAlternatives(String foodName) {
    return _data[foodName] ?? [];
  }

  List<String> getFoodGroups(String foodName) {
    final list = getAlternatives(foodName);
    final groups = list.map((a) => a.category).toSet().toList();
    return groups;
  }

  List<Alternative> getByGroup(String foodName, String group) {
    return getAlternatives(foodName)
        .where((a) => a.category == group)
        .toList();
  }
}