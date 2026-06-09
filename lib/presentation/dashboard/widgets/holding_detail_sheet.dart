import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/holding_model.dart';
import 'shared/gain_badge.dart';
import 'shared/stat_tile.dart';
import 'shared/symbol_avatar.dart';

/// Bottom sheet with a full breakdown of a single holding.
class HoldingDetailSheet extends StatelessWidget {
  final HoldingModel holding;
  final double allocationPercent;

  const HoldingDetailSheet({
    super.key,
    required this.holding,
    required this.allocationPercent,
  });

  static Future<void> show(
    BuildContext context, {
    required HoldingModel holding,
    required double allocationPercent,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HoldingDetailSheet(
        holding: holding,
        allocationPercent: allocationPercent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isProfit = holding.gainLoss >= 0;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          AppSpacing.lg,
          AppSpacing.xxl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                SymbolAvatar(symbol: holding.symbol, size: 52),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holding.symbol,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        holding.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                GainBadge(
                  label: Formatters.gainLossLabel(
                    amount: holding.gainLoss,
                    percent: holding.gainPercentage,
                  ),
                  isProfit: isProfit,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              Formatters.currency(holding.currentValue),
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${allocationPercent.toStringAsFixed(1)}% of portfolio',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: allocationPercent / 100,
                minHeight: 6,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Qty',
                    value: holding.units.toStringAsFixed(0),
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'LTP',
                    value: Formatters.currency(holding.currentPrice),
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'Avg Cost',
                    value: Formatters.currency(holding.avgCost),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Invested',
                    value: Formatters.currency(holding.investedValue),
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'Returns',
                    value: Formatters.currency(holding.gainLoss, showSign: true),
                    valueColor: isProfit ? AppColors.success : AppColors.loss,
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'Return %',
                    value: Formatters.percentage(holding.gainPercentage),
                    valueColor: isProfit ? AppColors.success : AppColors.loss,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
