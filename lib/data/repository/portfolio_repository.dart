import '../models/portfolio_model.dart';

abstract class PortfolioRepository {
  Future<PortfolioModel> getPortfolio();

  Future<PortfolioModel> refreshPortfolio();
}
