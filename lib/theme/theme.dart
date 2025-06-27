import 'package:flutter/material.dart';

class EcoEatsTheme {
  static const Color primaryBackground = Color(0xFF243e36); // Main dark green
  static const Color secondaryBackground = Color(0xFF6a994e);
  static const Color tertiaryBackground = Color(0xFFf1f7ed);
  static const Color mustardYellow = Color(0xFF8fc0a9);    // Used for background (item list area)
  static const Color butteryYellow = Color(0xFFFFFFEC);    // Used for input
  static const Color selectedBackground = Color(0xFF4F8742); // Consistent blue
  static const Color unselectedBackground = Color(0xFFE0E0E0);
  static const Color selectedText = Colors.white;
  static const Color unselectedText = Colors.black;

  static ThemeData get light => ThemeData(
    primaryColor: primaryBackground,
    scaffoldBackgroundColor: mustardYellow,
    cardTheme: CardThemeData(
      color: butteryYellow,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBackground,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: butteryYellow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );
}
