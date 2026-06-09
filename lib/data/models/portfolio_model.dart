import 'holding_model.dart';

class PortfolioModel {
  final String user;
  final List<HoldingModel> holdings;

  const PortfolioModel({
    required this.user,
    required this.holdings,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      user: json['user'] ?? '',
      holdings: (json['holdings'] as List<dynamic>? ?? [])
          .map((e) => HoldingModel.fromJson(e))
          .toList(),
    );
  }

  double get portfolioValue {
    return holdings.fold(
      0,
      (sum, item) => sum + item.currentValue,
    );
  }

  double get investedValue {
    return holdings.fold(
      0,
      (sum, item) => sum + item.investedValue,
    );
  }

  double get totalGain {
    return portfolioValue - investedValue;
  }

  double get gainPercentage {
    if (investedValue == 0) return 0;
    return (totalGain / investedValue) * 100;
  }
}