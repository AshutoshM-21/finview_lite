import 'holding_model.dart';

/// Aggregated portfolio data with JSON totals and per-holding metrics.
class PortfolioModel {
  final String user;
  final List<HoldingModel> holdings;
  final double? _jsonPortfolioValue;
  final double? _jsonTotalGain;

  const PortfolioModel({
    required this.user,
    required this.holdings,
    double? jsonPortfolioValue,
    double? jsonTotalGain,
  })  : _jsonPortfolioValue = jsonPortfolioValue,
        _jsonTotalGain = jsonTotalGain;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    final holdingsJson = json['holdings'];
    final List<HoldingModel> parsedHoldings = [];

    if (holdingsJson is List) {
      for (final item in holdingsJson) {
        if (item is Map<String, dynamic>) {
          parsedHoldings.add(HoldingModel.fromJson(item));
        } else if (item is Map) {
          parsedHoldings.add(
            HoldingModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return PortfolioModel(
      user: _parseString(json['user']),
      holdings: parsedHoldings,
      jsonPortfolioValue: _parseOptionalDouble(json['portfolio_value']),
      jsonTotalGain: _parseOptionalDouble(json['total_gain']),
    );
  }

  /// Sum of current values across listed holdings only.
  double get holdingsValue =>
      holdings.fold(0, (sum, item) => sum + item.currentValue);

  /// Sum of invested amounts across listed holdings only.
  double get holdingsInvestedValue =>
      holdings.fold(0, (sum, item) => sum + item.investedValue);

  /// Total portfolio value — uses JSON `portfolio_value` when provided.
  double get portfolioValue => _jsonPortfolioValue ?? holdingsValue;

  /// Total gain — uses JSON `total_gain` when provided.
  double get totalGain =>
      _jsonTotalGain ?? (holdingsValue - holdingsInvestedValue);

  /// Total amount invested, derived from portfolio value and gain.
  double get investedValue => portfolioValue - totalGain;

  /// Portion of portfolio not represented by listed holdings.
  double get unlistedValue =>
      (portfolioValue - holdingsValue).clamp(0, double.infinity);

  double get gainPercentage {
    if (investedValue == 0) return 0;
    return (totalGain / investedValue) * 100;
  }

  /// Holding with the highest gain percentage, if any holdings exist.
  HoldingModel? get topGainer {
    if (holdings.isEmpty) return null;
    return holdings.reduce(
      (best, item) =>
          item.gainPercentage > best.gainPercentage ? item : best,
    );
  }

  /// Holding with the lowest gain percentage, if any holdings exist.
  HoldingModel? get topLoser {
    if (holdings.isEmpty) return null;
    return holdings.reduce(
      (worst, item) =>
          item.gainPercentage < worst.gainPercentage ? item : worst,
    );
  }

  /// Holding with the largest current market value.
  HoldingModel? get largestHolding {
    if (holdings.isEmpty) return null;
    return holdings.reduce(
      (largest, item) =>
          item.currentValue > largest.currentValue ? item : largest,
    );
  }

  /// Portfolio weight of a holding as a percentage of total value.
  double allocationPercent(HoldingModel holding) {
    if (portfolioValue == 0) return 0;
    return (holding.currentValue / portfolioValue) * 100;
  }

  PortfolioModel copyWith({
    String? user,
    List<HoldingModel>? holdings,
    double? jsonPortfolioValue,
    double? jsonTotalGain,
  }) {
    return PortfolioModel(
      user: user ?? this.user,
      holdings: holdings ?? this.holdings,
      jsonPortfolioValue: jsonPortfolioValue ?? _jsonPortfolioValue,
      jsonTotalGain: jsonTotalGain ?? _jsonTotalGain,
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return 'Investor';
    final text = value.toString().trim();
    return text.isEmpty ? 'Investor' : text;
  }

  static double? _parseOptionalDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
