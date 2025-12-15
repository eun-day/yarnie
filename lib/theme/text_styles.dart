import 'package:flutter/material.dart';

class AppTextStyles {
  static const String _fontFamily = 'Inter';

  /// Title/H1
  /// Size: 24, Height: 32px, Spacing: 0.07px
  static const TextStyle titleH1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 32 / 24, // 1.33
    letterSpacing: 0.07,
    color: Colors.black, // Default color, can be overridden
  );

  /// Title/H2
  /// Size: 20, Height: 28px, Spacing: -0.45px
  static const TextStyle titleH2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 28 / 20, // 1.4
    letterSpacing: -0.45,
    color: Colors.black,
  );

  /// Title/H3
  /// Size: 16, Height: 24px, Spacing: -0.31px
  static const TextStyle titleH3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16, // 1.5
    letterSpacing: -0.31,
    color: Colors.black,
  );

  /// Body/M
  /// Size: 14, Height: 20px, Spacing: -0.15px
  static const TextStyle bodyM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // 1.43
    letterSpacing: -0.15,
    color: Colors.black,
  );
}
