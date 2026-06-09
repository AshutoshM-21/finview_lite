import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/portfolio_model.dart';
import 'shared/animated_value_text.dart';
import 'shared/app_card.dart';
import 'shared/gain_badge.dart';
import 'shared/stat_tile.dart';

/// Hero portfolio card with gradient background and key financial metrics.
class PortfolioSummaryCard extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioSummaryCard({
    super.key,
    required this.portfolio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isProfit = portfolio.totalGain >= 0;
    final gradient =
        isDark ? AppColors.heroGradientDark : AppColors.heroGradient;

    return AppCard(
      gradient: gradient,
      showBorder: false,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.waving_hand_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    Text(
                      portfolio.user,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'CURRENT VALUE',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedValueText(
            value: portfolio.portfolioValue,
            formatter: Formatters.currency,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GainBadge(
            label: Formatters.gainLossLabel(
              amount: portfolio.totalGain,
              percent: portfolio.gainPercentage,
            ),
            isProfit: isProfit,
            onDarkBackground: true,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Invested',
                    value: Formatters.currency(portfolio.investedValue),
                    onDarkBackground: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.lg),
                    child: StatTile(
                      label: 'Returns',
                      value: Formatters.percentage(portfolio.gainPercentage),
                      valueColor: isProfit
                          ? const Color(0xFF7CF5C8)
                          : const Color(0xFFFF9B9B),
                      onDarkBackground: true,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.lg),
                    child: StatTile(
                      label: 'Holdings',
                      value: '${portfolio.holdings.length}',
                      onDarkBackground: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
