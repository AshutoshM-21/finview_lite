import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/enums/holding_sort_option.dart';
import '../../../core/enums/return_display_mode.dart';
import '../../../data/models/portfolio_model.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../settings/cubit/theme_cubit.dart';
import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import '../widgets/allocation_chart_card.dart';
import '../widgets/empty_portfolio_widget.dart';
import '../widgets/holding_card.dart';
import '../widgets/portfolio_insights_row.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/return_toggle.dart';
import '../widgets/shared/dashboard_shimmer.dart';
import '../widgets/shared/section_header.dart';
import '../widgets/shared/staggered_entry.dart';
import '../widgets/sort_dropdown.dart';

/// Investment insights dashboard with Groww-inspired production UI.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const double _tabletBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            if (state is PortfolioInitial || state is PortfolioLoading) {
              return const DashboardShimmer();
            }

            if (state is PortfolioError) {
              return _ErrorView(message: state.message);
            }

            if (state is PortfolioLoaded) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () =>
                    context.read<PortfolioCubit>().refreshPortfolio(),
                child: _DashboardContent(
                  key: ValueKey(state.portfolio.portfolioValue),
                  portfolio: state.portfolio,
                  isRefreshing: state.isRefreshing,
                  lastUpdated: state.lastUpdated,
                ),
              );
            }

            return const DashboardShimmer();
          },
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final bool isRefreshing;
  final DateTime? lastUpdated;
  final VoidCallback onRefresh;

  const _DashboardHeader({
    required this.isRefreshing,
    required this.onRefresh,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinView Lite',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  lastUpdated != null
                      ? 'Updated ${_formatLastUpdated(lastUpdated!)}'
                      : 'Your portfolio at a glance',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            tooltip: 'Refresh prices',
            onPressed: isRefreshing ? null : onRefresh,
            icon: isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded, size: 20),
          ),
          _HeaderIconButton(
            tooltip: 'Toggle theme',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(
              context.watch<ThemeCubit>().state
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              size: 20,
            ),
          ),
          _HeaderIconButton(
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final String tooltip;
  final VoidCallback? onPressed;
  final Widget icon;

  const _HeaderIconButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          icon: icon,
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
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lossLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.loss,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Unable to load portfolio',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PortfolioCubit>().loadPortfolio(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatLastUpdated(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${time.day}/${time.month}/${time.year}';
}

class _DashboardContent extends StatefulWidget {
  final PortfolioModel portfolio;
  final bool isRefreshing;
  final DateTime? lastUpdated;

  const _DashboardContent({
    super.key,
    required this.portfolio,
    this.isRefreshing = false,
    this.lastUpdated,
  });

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

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _DashboardHeader(
                isRefreshing: widget.isRefreshing,
                lastUpdated: widget.lastUpdated,
                onRefresh: () =>
                    context.read<PortfolioCubit>().refreshPortfolio(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOutCubic,
                  child: Column(
                    key: ValueKey(widget.portfolio.portfolioValue),
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
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: AllocationChartCard(
                                  holdings: widget.portfolio.holdings,
                                  portfolioTotalValue:
                                      widget.portfolio.portfolioValue,
                                  unlistedValue:
                                      widget.portfolio.unlistedValue,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        PortfolioSummaryCard(portfolio: widget.portfolio),
                        const SizedBox(height: AppSpacing.lg),
                        AllocationChartCard(
                          holdings: widget.portfolio.holdings,
                          portfolioTotalValue:
                              widget.portfolio.portfolioValue,
                          unlistedValue: widget.portfolio.unlistedValue,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      PortfolioInsightsRow(portfolio: widget.portfolio),
                      const SizedBox(height: AppSpacing.xxl),
                      SectionHeader(
                        title: 'Your Holdings',
                        subtitle:
                            '${sortedHoldings.length} stocks in portfolio',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${sortedHoldings.length}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSurface
                              : AppColors.divider,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? AppColors.darkBorder
                                : AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [
                            ReturnToggle(
                              selectedMode: _returnMode,
                              onChanged: (mode) =>
                                  setState(() => _returnMode = mode),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SortDropdown(
                              selectedOption: _sortOption,
                              onChanged: (option) =>
                                  setState(() => _sortOption = option),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (sortedHoldings.isEmpty)
                        const EmptyPortfolioWidget()
                      else
                        ...sortedHoldings.asMap().entries.map(
                          (entry) => StaggeredEntry(
                            key: ValueKey(
                              '${entry.value.symbol}_${entry.value.currentPrice}',
                            ),
                            index: entry.key,
                            child: HoldingCard(
                              holding: entry.value,
                              returnDisplayMode: _returnMode,
                              allocationPercent: widget.portfolio
                                  .allocationPercent(entry.value),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
