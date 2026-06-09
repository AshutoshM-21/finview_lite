import 'package:flutter/material.dart';

/// Compact label + value pair used in summary and holding cards.
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool onDarkBackground;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.onDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelColor = onDarkBackground
        ? Colors.white.withValues(alpha: 0.7)
        : theme.colorScheme.onSurfaceVariant;
    final textColor = onDarkBackground
        ? Colors.white
        : (valueColor ?? theme.colorScheme.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: labelColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
