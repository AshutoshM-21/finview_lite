import 'package:flutter/material.dart';

/// Groww-inspired fintech color palette for FinView Lite.
abstract final class AppColors {
  static const Color primary = Color(0xFF5367FF);
  static const Color primaryDark = Color(0xFF3B4FD9);
  static const Color success = Color(0xFF00B386);
  static const Color successLight = Color(0xFFE6F9F3);
  static const Color loss = Color(0xFFE53535);
  static const Color lossLight = Color(0xFFFEECEC);
  static const Color background = Color(0xFFF6F7FB);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1B1F3B);
  static const Color textSecondary = Color(0xFF6B7289);
  static const Color border = Color(0xFFE8ECF4);
  static const Color divider = Color(0xFFF0F2F7);

  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkBorder = Color(0xFF2D333B);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2A5E), Color(0xFF5367FF)],
  );

  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1528), Color(0xFF2D3A8C)],
  );

  static const List<Color> chartPalette = [
    Color(0xFF5367FF),
    Color(0xFF00B386),
    Color(0xFFFF8C42),
    Color(0xFF9B5DE5),
    Color(0xFF00C2CB),
    Color(0xFFFF6B9D),
    Color(0xFF4ECDC4),
    Color(0xFFFFD166),
  ];

  static const List<Color> symbolAvatarColors = [
    Color(0xFF5367FF),
    Color(0xFF00B386),
    Color(0xFFFF8C42),
    Color(0xFF9B5DE5),
    Color(0xFF00C2CB),
    Color(0xFFE53535),
  ];
}
