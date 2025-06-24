import 'package:flutter/material.dart';

class EcoEatsTheme {
  static const Color selectedBackground = Colors.blueAccent; // Consistent blue
  static const Color unselectedBackground = Color(0xFFE0E0E0);
  static const Color selectedText = Colors.white;
  static const Color unselectedText = Colors.black;

  static ThemeData get light => ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );
}
