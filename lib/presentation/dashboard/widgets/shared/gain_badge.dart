import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Pill badge for displaying profit or loss values.
class GainBadge extends StatelessWidget {
  final String label;
  final bool isProfit;
  final bool onDarkBackground;

  const GainBadge({
    super.key,
    required this.label,
    required this.isProfit,
    this.onDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final gainColor = isProfit ? AppColors.success : AppColors.loss;

    Color background;
    Color textColor;

    if (onDarkBackground) {
      background = Colors.white.withValues(alpha: 0.15);
      textColor = isProfit ? const Color(0xFF7CF5C8) : const Color(0xFFFF9B9B);
    } else {
      background = isProfit ? AppColors.successLight : AppColors.lossLight;
      textColor = gainColor;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark && !onDarkBackground) {
      background = gainColor.withValues(alpha: 0.15);
      textColor = gainColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isProfit ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
