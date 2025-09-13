import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF3B82F6); // blue-500
  static const Color accent = Color(0xFF7C3AED); // purple-600

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // enables Material 3
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600), // headline6 → titleLarge
      bodyMedium: TextStyle(fontSize: 14), // bodyText2 → bodyMedium
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      ),
    ),
  );
}
