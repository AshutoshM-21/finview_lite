import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/enums/return_display_mode.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/holding_model.dart';

/// Reusable card displaying a single holding with wealth-management styling.
class HoldingCard extends StatelessWidget {
  final HoldingModel holding;
  final ReturnDisplayMode returnDisplayMode;

  const HoldingCard({
    super.key,
    required this.holding,
    required this.returnDisplayMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = holding.gainLoss >= 0;
    final gainColor = isProfit ? AppColors.success : AppColors.loss;
    final gainLabel = returnDisplayMode == ReturnDisplayMode.amount
        ? Formatters.currency(holding.gainLoss, showSign: true)
        : Formatters.percentage(holding.gainPercentage);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 480;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holding.symbol,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            holding.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: gainColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        gainLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: gainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isWide)
                  _buildWideMetrics(theme)
                else
                  _buildNarrowMetrics(theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideMetrics(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _MetricTile(label: 'Units', value: holding.units.toStringAsFixed(0))),
        Expanded(
          child: _MetricTile(
            label: 'Invested Value',
            value: Formatters.currency(holding.investedValue),
          ),
        ),
        Expanded(
          child: _MetricTile(
            label: 'Current Value',
            value: Formatters.currency(holding.currentValue),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowMetrics(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Units',
                value: holding.units.toStringAsFixed(0),
              ),
            ),
            Expanded(
              child: _MetricTile(
                label: 'Invested Value',
                value: Formatters.currency(holding.investedValue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MetricTile(
          label: 'Current Value',
          value: Formatters.currency(holding.currentValue),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
