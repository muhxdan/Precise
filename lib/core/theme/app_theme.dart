import 'package:flutter/material.dart';
import 'package:precise/core/theme/app_colors.dart';
import 'package:precise/core/theme/app_typography.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: AppTypography.textTheme(AppColors.lightOnBackground),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.lightOnBackground,
    ),
    colorScheme: ColorScheme.light(
      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primary.withOpacity(0.1),
      onPrimaryContainer: AppColors.primary,

      // Surface
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceContainerHighest: AppColors.lightContainerBackground,
      onSurfaceVariant: AppColors.lightOnSurface.withOpacity(0.75),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightOnBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 65,
      elevation: 0,
      indicatorColor: AppColors.primary,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return TextStyle(
          color: AppColors.navigationInactiveIconLight,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
      backgroundColor: AppColors.lightBackground,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.lightOnBackground,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.lightOnBackground,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.lightOnBackground,
          width: 2,
        ),
      ),
      hintStyle: TextStyle(
        color: AppColors.lightOnSurface.withOpacity(0.5),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightOnBackground.withOpacity(0.1),
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary; // Warna saat dipilih
        }
        return AppColors.lightSurface; // Warna saat tidak dipilih
      }),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: AppTypography.textTheme(AppColors.darkOnBackground),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.darkOnBackground,
    ),
    colorScheme: ColorScheme.dark(
      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primary.withOpacity(0.1),
      onPrimaryContainer: AppColors.primary,

      // Surface
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerHighest: AppColors.darkContainerBackground,
      onSurfaceVariant: AppColors.darkOnSurface.withOpacity(0.75),
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary; // Warna saat dipilih
        }
        return AppColors.darkBackground; // Warna saat tidak dipilih
      }),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkOnBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 65,
      elevation: 0,
      indicatorColor: AppColors.primary,
      backgroundColor: AppColors.darkBackground,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.darkOnBackground,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: AppColors.darkOnBackground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.darkOnBackground,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.darkOnBackground,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.darkOnBackground,
          width: 2,
        ),
      ),
      hintStyle: TextStyle(color: AppColors.darkOnSurface.withOpacity(0.5)),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkOnBackground.withOpacity(0.1),
    ),
  );
}
