import 'package:flutter_test/flutter_test.dart';

import 'package:finview_lite/data/models/holding_model.dart';
import 'package:finview_lite/data/models/portfolio_model.dart';

void main() {
  group('HoldingModel', () {
    test('parses valid JSON and computes metrics', () {
      final holding = HoldingModel.fromJson({
        'symbol': 'TCS',
        'name': 'Tata Consultancy',
        'units': 5,
        'avg_cost': 3200,
        'current_price': 3400,
      });

      expect(holding.investedValue, 16000);
      expect(holding.currentValue, 17000);
      expect(holding.gainLoss, 1000);
      expect(holding.gainPercentage, closeTo(6.25, 0.01));
    });

    test('handles missing fields without crashing', () {
      final holding = HoldingModel.fromJson({});

      expect(holding.symbol, '');
      expect(holding.units, 0);
      expect(holding.investedValue, 0);
      expect(holding.gainPercentage, 0);
    });

    test('handles zero investment safely', () {
      final holding = HoldingModel.fromJson({
        'units': 0,
        'avg_cost': 0,
        'current_price': 100,
      });

      expect(holding.gainPercentage, 0);
    });
  });

  group('PortfolioModel', () {
    test('parses holdings list and computes totals', () {
      final portfolio = PortfolioModel.fromJson({
        'user': 'Aarav Patel',
        'holdings': [
          {
            'symbol': 'TCS',
            'name': 'Tata Consultancy',
            'units': 5,
            'avg_cost': 3200,
            'current_price': 3400,
          },
          {
            'symbol': 'INFY',
            'name': 'Infosys Ltd',
            'units': 10,
            'avg_cost': 1400,
            'current_price': 1500,
          },
        ],
      });

      expect(portfolio.user, 'Aarav Patel');
      expect(portfolio.holdings.length, 2);
      expect(portfolio.portfolioValue, 32000);
      expect(portfolio.totalGain, 2000);
    });

    test('handles empty holdings list', () {
      final portfolio = PortfolioModel.fromJson({
        'user': '',
        'holdings': [],
      });

      expect(portfolio.user, 'Investor');
      expect(portfolio.portfolioValue, 0);
      expect(portfolio.gainPercentage, 0);
    });

    test('ignores invalid holding entries', () {
      final portfolio = PortfolioModel.fromJson({
        'holdings': [
          'invalid',
          {
            'symbol': 'TCS',
            'units': 1,
            'avg_cost': 100,
            'current_price': 110,
          },
        ],
      });

      expect(portfolio.holdings.length, 1);
    });
  });
}
