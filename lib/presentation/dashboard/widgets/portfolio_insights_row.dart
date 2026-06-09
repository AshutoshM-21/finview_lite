import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/holding_model.dart';
import '../../../data/models/portfolio_model.dart';
import 'shared/app_card.dart';
import 'shared/gain_badge.dart';

/// Quick-glance cards for top gainer, top loser, and largest holding.
class PortfolioInsightsRow extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioInsightsRow({
    super.key,
    required this.portfolio,
  });

  @override
  Widget build(BuildContext context) {
    if (portfolio.holdings.isEmpty) return const SizedBox.shrink();

    final insights = <_InsightData>[
      if (portfolio.topGainer != null)
        _InsightData(
          title: 'Top Gainer',
          holding: portfolio.topGainer!,
          icon: Icons.trending_up_rounded,
          accent: AppColors.success,
        ),
      if (portfolio.topLoser != null)
        _InsightData(
          title: 'Top Loser',
          holding: portfolio.topLoser!,
          icon: Icons.trending_down_rounded,
          accent: AppColors.loss,
        ),
      if (portfolio.largestHolding != null)
        _InsightData(
          title: 'Largest',
          holding: portfolio.largestHolding!,
          icon: Icons.pie_chart_rounded,
          accent: AppColors.primary,
          showAllocation: true,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;
        

        if (isWide) {
          return Row(
            children: [
              for (var i = 0; i < insights.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _InsightCard(
                    data: insights[i],
                    allocationPercent: portfolio.allocationPercent(
                      insights[i].holding,
                    ),
                  ),
                ),
              ],
            ],
          );
        }

        return SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: insights.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final insight = insights[index];
              return SizedBox(
                width: 168,
                
                child: _InsightCard(
                  data: insight,
                  allocationPercent:
                      portfolio.allocationPercent(insight.holding),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _InsightData {
  final String title;
  final HoldingModel holding;
  final IconData icon;
  final Color accent;
  final bool showAllocation;

  const _InsightData({
    required this.title,
    required this.holding,
    required this.icon,
    required this.accent,
    this.showAllocation = false,
  });
}

class _InsightCard extends StatelessWidget {
  final _InsightData data;
  final double allocationPercent;

  const _InsightCard({
    required this.data,
    required this.allocationPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProfit = data.holding.gainLoss >= 0;
    final metric = data.showAllocation
        ? '${allocationPercent.toStringAsFixed(1)}%'
        : Formatters.percentage(data.holding.gainPercentage);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: data.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 16, color: data.accent),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.title,
                  style: theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.holding.symbol,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.holding.name,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          if (data.showAllocation)
            Text(
              metric,
              style: theme.textTheme.titleSmall?.copyWith(
                color: data.accent,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            GainBadge(
              label: metric,
              isProfit: isProfit,
            ),
        ],
      ),
    );
  }
}
