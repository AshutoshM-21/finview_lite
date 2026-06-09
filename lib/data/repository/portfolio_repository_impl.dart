import '../datasource/portfolio_local_datasource.dart';
import '../models/portfolio_model.dart';
import 'portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource dataSource;

  PortfolioRepositoryImpl(this.dataSource);

  @override
  Future<PortfolioModel> getPortfolio() {
    return dataSource.getPortfolio();
  }

  @override
  Future<PortfolioModel> refreshPortfolio() {
    return dataSource.refreshPortfolio();
  }
}
