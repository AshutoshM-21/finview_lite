import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/enums/holding_sort_option.dart';

/// Minimal sort selector styled as a compact chip dropdown.
class SortDropdown extends StatelessWidget {
  final HoldingSortOption selectedOption;
  final ValueChanged<HoldingSortOption> onChanged;

  const SortDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<HoldingSortOption>(
          value: selectedOption,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          borderRadius: BorderRadius.circular(12),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
          items: HoldingSortOption.values
              .map(
                (option) => DropdownMenuItem<HoldingSortOption>(
                  value: option,
                  child: Text(option.label),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
