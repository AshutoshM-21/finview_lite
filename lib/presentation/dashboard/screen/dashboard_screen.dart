import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/enums/holding_sort_option.dart';
import '../../../core/enums/return_display_mode.dart';
import '../../../data/models/portfolio_model.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import '../widgets/allocation_chart_card.dart';
import '../widgets/empty_portfolio_widget.dart';
import '../widgets/holding_card.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/return_toggle.dart';
import '../widgets/sort_dropdown.dart';

/// Main dashboard screen with portfolio summary, allocation chart, and holdings.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const double _tabletBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            if (state is PortfolioLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PortfolioError) {
              return _ErrorView(message: state.message);
            }

            if (state is PortfolioLoaded) {
              return _DashboardContent(portfolio: state.portfolio);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.loss,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PortfolioCubit>().loadPortfolio(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  final PortfolioModel portfolio;

  const _DashboardContent({required this.portfolio});

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  ReturnDisplayMode _returnMode = ReturnDisplayMode.amount;
  HoldingSortOption _sortOption = HoldingSortOption.currentValue;

  @override
  Widget build(BuildContext context) {
    final sortedHoldings = _sortOption.sort(widget.portfolio.holdings);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= DashboardScreen._tabletBreakpoint;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: PortfolioSummaryCard(
                          portfolio: widget.portfolio,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AllocationChartCard(
                          holdings: widget.portfolio.holdings,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                PortfolioSummaryCard(portfolio: widget.portfolio),
                const SizedBox(height: 16),
                AllocationChartCard(holdings: widget.portfolio.holdings),
              ],
              const SizedBox(height: 24),
              Text(
                'Holdings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ReturnToggle(
                    selectedMode: _returnMode,
                    onChanged: (mode) => setState(() => _returnMode = mode),
                  ),
                  SizedBox(
                    width: isWide ? 200 : double.infinity,
                    child: SortDropdown(
                      selectedOption: _sortOption,
                      onChanged: (option) =>
                          setState(() => _sortOption = option),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sortedHoldings.isEmpty)
                const EmptyPortfolioWidget()
              else
                ...sortedHoldings.map(
                  (holding) => HoldingCard(
                    holding: holding,
                    returnDisplayMode: _returnMode,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
