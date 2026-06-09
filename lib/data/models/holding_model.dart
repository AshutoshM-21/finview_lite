/// Represents a single investment holding with computed financial metrics.
class HoldingModel {
  final String symbol;
  final String name;
  final double units;
  final double avgCost;
  final double currentPrice;

  const HoldingModel({
    required this.symbol,
    required this.name,
    required this.units,
    required this.avgCost,
    required this.currentPrice,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      symbol: _parseString(json['symbol']),
      name: _parseString(json['name']),
      units: _parseDouble(json['units']),
      avgCost: _parseDouble(json['avg_cost']),
      currentPrice: _parseDouble(json['current_price']),
    );
  }

  double get investedValue => units * avgCost;

  double get currentValue => units * currentPrice;

  double get gainLoss => currentValue - investedValue;

  double get gainPercentage {
    if (investedValue == 0) return 0;
    return (gainLoss / investedValue) * 100;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
