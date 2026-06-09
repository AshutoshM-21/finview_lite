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
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      units: (json['units'] ?? 0).toDouble(),
      avgCost: (json['avg_cost'] ?? 0).toDouble(),
      currentPrice: (json['current_price'] ?? 0).toDouble(),
    );
  }

  double get investedValue => units * avgCost;

  double get currentValue => units * currentPrice;

  double get gainLoss => currentValue - investedValue;

  double get gainPercentage {
    if (investedValue == 0) return 0;
    return (gainLoss / investedValue) * 100;
  }
}