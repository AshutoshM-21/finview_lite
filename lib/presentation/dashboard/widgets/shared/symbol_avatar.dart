import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Circular avatar displaying a stock symbol, Groww-style.
class SymbolAvatar extends StatelessWidget {
  final String symbol;
  final double size;

  const SymbolAvatar({
    super.key,
    required this.symbol,
    this.size = AppSpacing.avatarSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = symbol.isEmpty
        ? 0
        : symbol.codeUnitAt(0) % AppColors.symbolAvatarColors.length;
    final background = AppColors.symbolAvatarColors[colorIndex];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: background.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.length >= 2 ? symbol.substring(0, 2) : symbol,
        style: TextStyle(
          color: background,
          fontSize: size * 0.32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
