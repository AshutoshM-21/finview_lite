/// Currency and percentage formatting utilities for portfolio display.
abstract final class Formatters {
  static String currency(double value, {bool showSign = false}) {
    final isNegative = value < 0;
    final absValue = value.abs();
    final integerPart = absValue.round();
    final formatted = _addIndianCommas(integerPart.toString());
    final sign = showSign
        ? (isNegative ? '-' : value > 0 ? '+' : '')
        : (isNegative ? '-' : '');
    return '$sign₹$formatted';
  }

  static String percentage(double value, {bool showSign = true}) {
    final isNegative = value < 0;
    final sign = showSign
        ? (isNegative ? '-' : value > 0 ? '+' : '')
        : (isNegative ? '-' : '');
    return '$sign${value.abs().toStringAsFixed(2)}%';
  }

  static String gainLossLabel({
    required double amount,
    required double percent,
  }) {
    return '${currency(amount, showSign: true)} (${percentage(percent)})';
  }

  static String _addIndianCommas(String digits) {
    if (digits.length <= 3) return digits;

    final lastThree = digits.substring(digits.length - 3);
    final remaining = digits.substring(0, digits.length - 3);
    final withCommas = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '$withCommas,$lastThree';
  }
}
