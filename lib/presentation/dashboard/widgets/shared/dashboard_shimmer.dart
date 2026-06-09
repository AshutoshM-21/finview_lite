import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'app_card.dart';

/// Skeleton placeholder shown while portfolio data is loading.
class DashboardShimmer extends StatefulWidget {
  const DashboardShimmer({super.key});

  @override
  State<DashboardShimmer> createState() => _DashboardShimmerState();
}

class _DashboardShimmerState extends State<DashboardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkSurface : AppColors.divider;
    final highlight = isDark ? AppColors.darkBorder : AppColors.border;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    _ShimmerBox(
                      width: 42,
                      height: 42,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: 12,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(
                            height: 16,
                            animation: _controller,
                            base: base,
                            highlight: highlight,
                            radius: 6,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _ShimmerBox(
                            height: 12,
                            width: 140,
                            animation: _controller,
                            base: base,
                            highlight: highlight,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ShimmerBox(
                      width: 40,
                      height: 40,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: 12,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _ShimmerBox(
                      height: 220,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: AppSpacing.cardRadius,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ShimmerBox(
                      height: 280,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: AppSpacing.cardRadius,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _ShimmerBox(
                            height: 120,
                            animation: _controller,
                            base: base,
                            highlight: highlight,
                            radius: AppSpacing.cardRadius,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _ShimmerBox(
                            height: 120,
                            animation: _controller,
                            base: base,
                            highlight: highlight,
                            radius: AppSpacing.cardRadius,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _ShimmerBox(
                            height: 120,
                            animation: _controller,
                            base: base,
                            highlight: highlight,
                            radius: AppSpacing.cardRadius,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ShimmerBox(
                      height: 88,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: AppSpacing.cardRadius,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ShimmerBox(
                      height: 140,
                      animation: _controller,
                      base: base,
                      highlight: highlight,
                      radius: AppSpacing.cardRadius,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final Animation<double> animation;
  final Color base;
  final Color highlight;
  final double radius;

  const _ShimmerBox({
    this.width,
    required this.height,
    required this.animation,
    required this.base,
    required this.highlight,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(-1 + animation.value * 2, 0),
            end: Alignment(1 + animation.value * 2, 0),
            colors: [base, highlight, base],
          ),
        ),
      ),
    );
  }
}
