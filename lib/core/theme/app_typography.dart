import 'package:flutter/material.dart';

class AppTypography {
  static TextTheme textTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: "Guardian",
          fontSize: 57,
          fontWeight: FontWeight.bold,
          color: color),
      displayMedium: TextStyle(
          fontFamily: "Guardian",
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: color),
      displaySmall: TextStyle(
          fontFamily: "Guardian",
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: color),
      headlineLarge: TextStyle(
          fontFamily: "Guardian",
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: color),
      headlineMedium: TextStyle(
          fontFamily: "Guardian",
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: color),
      headlineSmall: TextStyle(
          fontFamily: "Guardian",
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: color),
      titleLarge: TextStyle(
          fontFamily: "Guardian",
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: color),
      titleMedium: TextStyle(
          fontFamily: "Guardian",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color),
      titleSmall: TextStyle(
          fontFamily: "Guardian",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color),
      bodyLarge: TextStyle(
          fontFamily: "Guardian",
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: color),
      bodyMedium: TextStyle(
          fontFamily: "Guardian",
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: color),
      bodySmall: TextStyle(
          fontFamily: "Guardian",
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: color),
      labelLarge: TextStyle(
          fontFamily: "Guardian",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color),
      labelMedium: TextStyle(
          fontFamily: "Guardian",
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color),
      labelSmall: TextStyle(
          fontFamily: "Guardian",
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color),
    );
  }
}
