import 'package:finview_lite/data/repository/portfolio_repository.dart';

import '../datasource/portfolio_local_datasource.dart';
import '../models/portfolio_model.dart';

class PortfolioRepositoryImpl
    implements PortfolioRepository {
  final PortfolioLocalDataSource dataSource;

  PortfolioRepositoryImpl(this.dataSource);

  @override
  Future<PortfolioModel> getPortfolio() {
    return dataSource.getPortfolio();
  }
}