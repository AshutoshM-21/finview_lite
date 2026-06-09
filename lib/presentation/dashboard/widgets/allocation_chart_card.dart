import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/holding_model.dart';

/// Pie chart card showing asset allocation by current holding value.
class AllocationChartCard extends StatelessWidget {
  final List<HoldingModel> holdings;

  const AllocationChartCard({
    super.key,
    required this.holdings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalValue = holdings.fold<double>(
      0,
      (sum, holding) => sum + holding.currentValue,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Allocation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            if (holdings.isEmpty || totalValue == 0)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text('No allocation data available'),
                ),
              )
            else ...[
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildSections(holdings, totalValue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: List.generate(holdings.length, (index) {
                  final holding = holdings[index];
                  final color = AppColors.chartPalette[
                      index % AppColors.chartPalette.length];
                  return _LegendItem(
                    color: color,
                    label: holding.symbol,
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    List<HoldingModel> holdings,
    double totalValue,
  ) {
    return List.generate(holdings.length, (index) {
      final holding = holdings[index];
      final color =
          AppColors.chartPalette[index % AppColors.chartPalette.length];
      final percentage = (holding.currentValue / totalValue) * 100;

      return PieChartSectionData(
        color: color,
        value: holding.currentValue,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 56,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    });
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
