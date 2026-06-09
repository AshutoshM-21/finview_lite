import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'shared/app_card.dart';

/// Illustrated empty state when no holdings are present.
class EmptyPortfolioWidget extends StatelessWidget {
  const EmptyPortfolioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.success.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.savings_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'No Investments Found',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add investments to start tracking your portfolio.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
