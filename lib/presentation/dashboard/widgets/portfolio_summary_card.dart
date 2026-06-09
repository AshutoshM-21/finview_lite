import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/portfolio_model.dart';

/// Header card displaying greeting, portfolio value, and total gain/loss.
class PortfolioSummaryCard extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioSummaryCard({
    super.key,
    required this.portfolio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = portfolio.totalGain >= 0;
    final gainColor = isProfit ? AppColors.success : AppColors.loss;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${portfolio.user} 👋',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Portfolio Value',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.currency(portfolio.portfolioValue),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.gainLossLabel(
                amount: portfolio.totalGain,
                percent: portfolio.gainPercentage,
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                color: gainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
