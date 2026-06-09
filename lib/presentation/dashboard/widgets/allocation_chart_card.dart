import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/holding_model.dart';
import 'shared/app_card.dart';

/// Donut chart showing portfolio allocation against total portfolio value.
class AllocationChartCard extends StatelessWidget {
  final List<HoldingModel> holdings;
  final double portfolioTotalValue;
  final double unlistedValue;

  const AllocationChartCard({
    super.key,
    required this.holdings,
    required this.portfolioTotalValue,
    this.unlistedValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.donut_large_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asset Allocation',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Distribution by current value',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (holdings.isEmpty && unlistedValue == 0)
            SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart_outline_rounded,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No allocation data',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 58,
                      sections: _buildSections(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TOTAL',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        Formatters.currency(portfolioTotalValue),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ...List.generate(holdings.length, (index) {
              final holding = holdings[index];
              final color =
                  AppColors.chartPalette[index % AppColors.chartPalette.length];
              final share = portfolioTotalValue > 0
                  ? (holding.currentValue / portfolioTotalValue) * 100
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _AllocationRow(
                  color: color,
                  symbol: holding.symbol,
                  value: holding.currentValue,
                  percentage: share,
                ),
              );
            }),
            if (unlistedValue > 0)
              _AllocationRow(
                color: AppColors.textSecondary,
                symbol: 'Other',
                value: unlistedValue,
                percentage: portfolioTotalValue > 0
                    ? (unlistedValue / portfolioTotalValue) * 100
                    : 0,
              ),
          ],
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final sections = <PieChartSectionData>[];

    for (var index = 0; index < holdings.length; index++) {
      final holding = holdings[index];
      final color =
          AppColors.chartPalette[index % AppColors.chartPalette.length];

      sections.add(
        PieChartSectionData(
          color: color,
          value: holding.currentValue,
          radius: 52,
          showTitle: false,
        ),
      );
    }

    if (unlistedValue > 0) {
      sections.add(
        PieChartSectionData(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          value: unlistedValue,
          radius: 52,
          showTitle: false,
        ),
      );
    }

    return sections;
  }
}

class _AllocationRow extends StatelessWidget {
  final Color color;
  final String symbol;
  final double value;
  final double percentage;

  const _AllocationRow({
    required this.color,
    required this.symbol,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            symbol,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          Formatters.currency(value),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
