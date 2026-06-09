import 'package:flutter/material.dart';

/// Centralized color palette for FinView Lite.
abstract final class AppColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color success = Color(0xFF22C55E);
  static const Color loss = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  /// Distinct colors for pie chart slices and legend indicators.
  static const List<Color> chartPalette = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEC4899),
    Color(0xFF6366F1),
    Color(0xFF14B8A6),
  ];
}
