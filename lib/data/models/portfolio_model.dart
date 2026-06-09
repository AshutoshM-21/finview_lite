import 'holding_model.dart';

/// Aggregated portfolio data with derived totals.
class PortfolioModel {
  final String user;
  final List<HoldingModel> holdings;

  const PortfolioModel({
    required this.user,
    required this.holdings,
  });

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
    );
  }

  double get portfolioValue =>
      holdings.fold(0, (sum, item) => sum + item.currentValue);

  double get investedValue =>
      holdings.fold(0, (sum, item) => sum + item.investedValue);

  double get totalGain => portfolioValue - investedValue;

  double get gainPercentage {
    if (investedValue == 0) return 0;
    return (totalGain / investedValue) * 100;
  }

  static String _parseString(dynamic value) {
    if (value == null) return 'Investor';
    final text = value.toString().trim();
    return text.isEmpty ? 'Investor' : text;
  }
}
