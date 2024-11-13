import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent Colors
  static const primary = Color(0xFF052963);
  static const onPrimary = Colors.white;

  // Light Theme Colors
  static const lightBackground = Colors.white;
  static const lightSurface = Colors.white;
  static const lightOnBackground = Colors.black;
  static const lightOnSurface = Colors.black;

  // Dark Theme Colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF121212);
  static const darkOnBackground = Colors.white;
  static const darkOnSurface = Colors.white;

  // Container Colors
  static final lightContainerBackground = Colors.black.withOpacity(0.05);
  static final darkContainerBackground = Colors.white.withOpacity(0.05);

  // Navigation Colors
  static const navigationIndicatorLight = primary;
  static const navigationIndicatorDark = primary;
  static const navigationActiveIconLight = lightOnBackground;
  static const navigationActiveIconDark = darkOnBackground;
  static final navigationInactiveIconLight =
      lightOnBackground.withOpacity(0.75);
  static final navigationInactiveIconDark = darkOnBackground.withOpacity(0.75);
}
