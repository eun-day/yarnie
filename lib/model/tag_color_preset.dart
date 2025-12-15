import 'dart:ui';
import 'package:flutter/material.dart';

class TagColorPreset {
  final String name;
  final Color backgroundColor;
  final Color textColor;

  const TagColorPreset({
    required this.name,
    required this.backgroundColor,
    required this.textColor,
  });

  static const List<TagColorPreset> all = [
    TagColorPreset(name: 'Blue', backgroundColor: Color(0xFFDBEAFE), textColor: Color(0xFF1D4ED8)),
    TagColorPreset(name: 'Purple', backgroundColor: Color(0xFFF3E8FF), textColor: Color(0xFF7E22CE)),
    TagColorPreset(name: 'Pink', backgroundColor: Color(0xFFFCE7F3), textColor: Color(0xFFBE185D)),
    TagColorPreset(name: 'Green', backgroundColor: Color(0xFFDCFCE7), textColor: Color(0xFF15803D)),
    TagColorPreset(name: 'Orange', backgroundColor: Color(0xFFFFEDD5), textColor: Color(0xFFDB5823)),
    TagColorPreset(name: 'Gray', backgroundColor: Color(0xFFE2E8F0), textColor: Color(0xFF1E293B)),
    TagColorPreset(name: 'Red', backgroundColor: Color(0xFFFEE2E2), textColor: Color(0xFFB91C1C)),
    TagColorPreset(name: 'Yellow', backgroundColor: Color(0xFFFEF9C3), textColor: Color(0xFFA16207)),
    TagColorPreset(name: 'Brown', backgroundColor: Color(0xFFEDD9C8), textColor: Color(0xFF6C4938)),
    TagColorPreset(name: 'Basic', backgroundColor: Color(0xFFF3F4F6), textColor: Color(0xFF374151)),
  ];

  /// Returns the text color for the given background color value if it matches a preset.
  /// Returns null if no match is found.
  static Color? getTextColor(int backgroundColorValue) {
    try {
      return all.firstWhere((p) => p.backgroundColor.value == backgroundColorValue).textColor;
    } catch (_) {
      return null;
    }
  }
}
