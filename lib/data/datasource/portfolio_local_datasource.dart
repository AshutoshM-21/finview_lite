import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/portfolio_model.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioModel> getPortfolio();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  static const String _assetPath = 'assets/portfolio.json';

  @override
  Future<PortfolioModel> getPortfolio() async {
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
    } on FlutterError {
      throw Exception('Portfolio data file not found');
    } on FormatException catch (e) {
      throw Exception('Invalid portfolio data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load portfolio');
    }
  }
}
