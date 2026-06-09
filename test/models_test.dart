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
    test('parses JSON portfolio totals when provided', () {
      final portfolio = PortfolioModel.fromJson({
        'user': 'Aarav Patel',
        'portfolio_value': 150000,
        'total_gain': 12000,
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
      expect(portfolio.holdingsValue, 32000);
      expect(portfolio.portfolioValue, 150000);
      expect(portfolio.totalGain, 12000);
      expect(portfolio.investedValue, 138000);
      expect(portfolio.unlistedValue, 118000);
    });

    test('falls back to computed totals when JSON totals are missing', () {
      final portfolio = PortfolioModel.fromJson({
        'user': 'Aarav Patel',
        'holdings': [
          {
            'symbol': 'TCS',
            'units': 5,
            'avg_cost': 3200,
            'current_price': 3400,
          },
        ],
      });

      expect(portfolio.portfolioValue, 17000);
      expect(portfolio.totalGain, 1000);
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

    test('identifies top gainer, loser, and largest holding', () {
      final portfolio = PortfolioModel.fromJson({
        'portfolio_value': 50000,
        'holdings': [
          {
            'symbol': 'TCS',
            'units': 5,
            'avg_cost': 3200,
            'current_price': 3400,
          },
          {
            'symbol': 'INFY',
            'units': 10,
            'avg_cost': 1400,
            'current_price': 1500,
          },
          {
            'symbol': 'RELI',
            'units': 2,
            'avg_cost': 2500,
            'current_price': 2000,
          },
        ],
      });

      expect(portfolio.topGainer?.symbol, 'TCS');
      expect(portfolio.topLoser?.symbol, 'RELI');
      expect(portfolio.largestHolding?.symbol, 'INFY');
      expect(
        portfolio.allocationPercent(portfolio.largestHolding!),
        closeTo(30, 0.1),
      );
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
