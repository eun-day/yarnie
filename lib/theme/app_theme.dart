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

extension YarnieThemeX on BuildContext {
  bool get isDarkMode => Theme.of(this).colorScheme.brightness == Brightness.dark;

  // 1. Part Tab Colors
  Color get selectedPartBg => isDarkMode ? const Color(0xFF2A502A) : const Color(0xFF6FB96F);
  Color get selectedPartText => isDarkMode ? Colors.white.withValues(alpha: 0.65) : Colors.white;
  Color get unselectedPartBg => isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFECEEF2);
  Color get unselectedPartText => isDarkMode ? Theme.of(this).colorScheme.onSurfaceVariant : const Color(0xFF030213);
  Color get unselectedPartBorderColor => isDarkMode ? Theme.of(this).colorScheme.outline : Colors.transparent;

  Color partTabBg(bool isSelected) {
    return isSelected ? selectedPartBg : unselectedPartBg;
  }

  Color partTabText(bool isSelected) {
    return isSelected ? selectedPartText : unselectedPartText;
  }

  BoxBorder? partTabBorder(bool isSelected) {
    if (isSelected) return null;
    return Border.all(
      color: unselectedPartBorderColor,
      width: 0.8,
    );
  }

  // 2. Main Counter Colors
  Color get counterIncrementBg => isDarkMode ? const Color(0xFF2A502A) : const Color(0xFF6FB96F);
  Color get counterDecrementBg => isDarkMode ? const Color(0xFF465338) : const Color(0xFFC0D2A4);
  Color get counterIconColor => isDarkMode ? Colors.white.withValues(alpha: 0.65) : Colors.white;
  Color get counterValueText => isDarkMode ? Theme.of(this).colorScheme.secondary : const Color(0xFF030213);
  Color get counterSettingsIcon => isDarkMode ? Colors.white.withValues(alpha: 0.65) : Theme.of(this).colorScheme.surface;
  Color get counterDecSplash => isDarkMode ? const Color(0xFF2D3624) : const Color(0xFF7D8D6A);
  Color get counterDecHighlight => isDarkMode ? const Color(0xFF38422D) : const Color(0xFFAABF93);
  Color get counterIncSplash => isDarkMode ? const Color(0xFF193219) : const Color(0xFF4C8A4C);
  Color get counterIncHighlight => isDarkMode ? const Color(0xFF213F21) : const Color(0xFF63A763);
  Color get mainCounterBorderColor => isDarkMode ? Theme.of(this).colorScheme.outline : const Color(0xFFF3F4F6);

  // 3. Session Timer Button Colors
  Color get sessionPausedBg => isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFECEEF2);
  Color get sessionPausedText => isDarkMode ? Theme.of(this).colorScheme.onSurfaceVariant : const Color(0xFF030213);
  Color get sessionActiveText => isDarkMode ? Colors.white.withValues(alpha: 0.65) : Theme.of(this).colorScheme.surface;
  Color get sessionPausedBorderColor => isDarkMode ? Theme.of(this).colorScheme.outline : Colors.transparent;

  Color sessionButtonBg(bool isRunning) {
    return isRunning
        ? sessionPausedBg
        : Theme.of(this).colorScheme.primary;
  }

  BoxBorder? sessionButtonBorder(bool isRunning) {
    if (!isRunning) return null;
    return Border.all(
      color: sessionPausedBorderColor,
      width: 0.8,
    );
  }

  // 4. Input & Action Button Colors (Save, Reset, etc.)
  Color get saveBtnBg => isDarkMode ? const Color(0xFF2A502A) : const Color(0xFF6FB96F);
  Color get saveBtnText => isDarkMode ? Colors.white.withValues(alpha: 0.65) : Theme.of(this).colorScheme.surface;
  Color get resetBtnBorderColor => isDarkMode ? Theme.of(this).colorScheme.outline : const Color.fromRGBO(0, 0, 0, 0.1);

  // 5. Buddy Counter Colors
  Color get counterLabelColor => isDarkMode ? Theme.of(this).colorScheme.onSurfaceVariant : Theme.of(this).colorScheme.onSurface;
  Color get buddySettingsIcon => isDarkMode ? Theme.of(this).colorScheme.onSurfaceVariant : Theme.of(this).colorScheme.onSurface;
  Color get buddyValueText => isDarkMode ? Colors.white.withValues(alpha: 0.5) : Theme.of(this).colorScheme.onSurface;

  // 6. Section Link & Status Colors
  Color get completedCardBg => isDarkMode ? const Color(0xFF2A502A).withValues(alpha: 0.15) : const Color(0xFFF0FDF4);
  Color get unlinkedCardBg => isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF8F9FA);

  // 7. Input Field Colors
  Color get inputFieldBg => isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F3F5);
  Color get numberInputBg => isDarkMode ? Theme.of(this).colorScheme.surfaceContainerHighest : const Color(0xFFF3F3F5);

  // 8. Header & Text Colors (Black in Light Mode)
  Color get headerIconColor => isDarkMode ? Colors.white.withValues(alpha: 0.65) : const Color(0xFF030213);
  Color get headerTitleColor => isDarkMode ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF030213);
  Color get popupMenuTextColor => isDarkMode ? Theme.of(this).colorScheme.onSurfaceVariant : const Color(0xFF030213);
  Color get sessionTimerTextColor => isDarkMode ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF030213);
}
