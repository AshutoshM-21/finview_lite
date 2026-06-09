import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/holding_model.dart';
import '../models/portfolio_model.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioModel> getPortfolio();

  /// Simulates live market price updates on each refresh.
  Future<PortfolioModel> refreshPortfolio();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  static const String _assetPath = 'assets/portfolio.json';

  PortfolioModel? _cachedPortfolio;
  final Random _random = Random();

  @override
  Future<PortfolioModel> getPortfolio() async {
    if (_cachedPortfolio != null) {
      return _cachedPortfolio!;
    }

    _cachedPortfolio = await _loadFromAsset();
    return _cachedPortfolio!;
  }

  @override
  Future<PortfolioModel> refreshPortfolio() async {
    final current = await getPortfolio();

    final updatedHoldings = current.holdings.map((holding) {
      // Simulate ±3% price movement per refresh.
      final fluctuation = 0.97 + _random.nextDouble() * 0.06;
      final updatedPrice = (holding.currentPrice * fluctuation)
          .clamp(0.01, double.infinity)
          .toDouble();

      return HoldingModel(
        symbol: holding.symbol,
        name: holding.name,
        units: holding.units,
        avgCost: holding.avgCost,
        currentPrice: double.parse(updatedPrice.toStringAsFixed(2)),
      );
    }).toList();

    _cachedPortfolio = PortfolioModel(
      user: current.user,
      holdings: updatedHoldings,
    );

    // Brief delay to mimic network latency.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return _cachedPortfolio!;
  }

  Future<PortfolioModel> _loadFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);

      if (jsonString.trim().isEmpty) {
        return const PortfolioModel(user: 'Investor', holdings: []);
      }

      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is! Map<String, dynamic>) {
        if (decoded is Map) {
          return PortfolioModel.fromJson(Map<String, dynamic>.from(decoded));
        }
        throw const FormatException('Portfolio JSON must be a map');
      }

      return PortfolioModel.fromJson(decoded);
    } on PlatformException {
      throw Exception('Portfolio data file not found');
    } on FormatException catch (e) {
      throw Exception('Invalid portfolio data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load portfolio');
    }
  }
}
