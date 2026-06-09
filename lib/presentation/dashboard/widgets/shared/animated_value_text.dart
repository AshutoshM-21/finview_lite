import 'package:flutter/material.dart';

/// Smoothly animates numeric text when the underlying value changes.
class AnimatedValueText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String Function(double value) formatter;
  final Duration duration;

  const AnimatedValueText({
    super.key,
    required this.value,
    required this.formatter,
    this.style,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Text(
          formatter(animatedValue),
          style: style,
        );
      },
    );
  }
}
