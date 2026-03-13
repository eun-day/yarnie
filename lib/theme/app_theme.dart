import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Light)
  static const Color primary = Color(0xFF637069);
  static const Color secondary = Color(0xFFC0D2A4);
  static const Color error = Color(0xFFD4183D);

  // Twitter Dim Theme Colors
  static const Color dimBackground = Color(0xFF15202B);
  static const Color dimSurface = Color(0xFF22303C);
  static const Color dimTextPrimary = Color(0xFFF5F8FA);
  static const Color dimTextSecondary = Color(0xFF8B98A5);

  // Light Theme Neutrals
  static const Color lightTextPrimary = Color(0xFF0A0A0A);
  static const Color lightTextSecondary = Color(0xFF717182);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightMuted = Color(0xFFECECF0);
}

class AppTheme {
  static ColorScheme get lightScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightMuted,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: const Color(0x1A000000),
    );
  }

  static ColorScheme get darkScheme {
    // Twitter Dim based Dark Mode
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.dimSurface,
      onSurface: AppColors.dimTextPrimary,
      surfaceContainerHighest: Color(0xFF2F3336), // Slightly lighter than surface
      onSurfaceVariant: AppColors.dimTextSecondary,
      outline: Color(0xFF38444D),
      background: AppColors.dimBackground,
      onBackground: AppColors.dimTextPrimary,
    );
  }

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
  }
}
