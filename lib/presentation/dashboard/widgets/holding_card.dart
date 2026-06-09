import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/enums/return_display_mode.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/holding_model.dart';
import 'holding_detail_sheet.dart';
import 'shared/app_card.dart';
import 'shared/gain_badge.dart';
import 'shared/stat_tile.dart';
import 'shared/symbol_avatar.dart';

/// Compact Groww-style holding row with symbol avatar and financial metrics.
class HoldingCard extends StatelessWidget {
  final HoldingModel holding;
  final ReturnDisplayMode returnDisplayMode;
  final double allocationPercent;

  const HoldingCard({
    super.key,
    required this.holding,
    required this.returnDisplayMode,
    this.allocationPercent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = holding.gainLoss >= 0;
    final gainLabel = returnDisplayMode == ReturnDisplayMode.amount
        ? Formatters.currency(holding.gainLoss, showSign: true)
        : Formatters.percentage(holding.gainPercentage);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            onTap: () => HoldingDetailSheet.show(
              context,
              holding: holding,
              allocationPercent: allocationPercent,
            ),
            child: Column(
              children: [
                Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SymbolAvatar(symbol: holding.symbol),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holding.symbol,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        holding.name,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.currency(holding.currentValue),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GainBadge(label: gainLabel, isProfit: isProfit),
                  ],
                ),
                ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Divider(
                  height: 1,
                  color: theme.dividerColor,
                ),
                const SizedBox(height: AppSpacing.md),
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
                        label: 'Avg Price',
                        value: Formatters.currency(holding.avgCost),
                      ),
                    ),
                    Expanded(
                      child: StatTile(
                        label: 'Invested',
                        value: Formatters.currency(holding.investedValue),
                      ),
                    ),
                  ],
                ),
                if (allocationPercent > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Text(
                        'Portfolio weight',
                        style: theme.textTheme.labelMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${allocationPercent.toStringAsFixed(1)}%',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: allocationPercent / 100,
                      minHeight: 4,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
