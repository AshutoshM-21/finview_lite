import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/portfolio_model.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioModel> getPortfolio();
}

class PortfolioLocalDataSourceImpl
    implements PortfolioLocalDataSource {

  @override
  Future<PortfolioModel> getPortfolio() async {
    try {
      final jsonString =
          await rootBundle.loadString(
        'assets/portfolio.json',
      );

      final jsonMap =
          jsonDecode(jsonString);

      return PortfolioModel.fromJson(
        jsonMap,
      );
    } catch (e) {
      throw Exception(
        'Failed to load portfolio',
      );
    }
  }
}