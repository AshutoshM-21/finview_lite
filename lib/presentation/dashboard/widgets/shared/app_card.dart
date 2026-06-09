import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Bordered surface card used consistently across the dashboard.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
    this.color,
    this.gradient,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? Theme.of(context).cardTheme.color) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: showBorder
            ? Border.all(
                color: gradient != null
                    ? Colors.transparent
                    : (isDark ? AppColors.darkBorder : AppColors.border),
              )
            : null,
        boxShadow: gradient != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
