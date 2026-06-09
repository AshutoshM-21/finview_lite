import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/portfolio_repository.dart';
import 'portfolio_state.dart';

/// Loads and refreshes portfolio data from the local repository.
class PortfolioCubit extends Cubit<PortfolioState> {
  final PortfolioRepository repository;

  PortfolioCubit(this.repository) : super(PortfolioInitial());

  Future<void> loadPortfolio() async {
    try {
      emit(PortfolioLoading());

      final portfolio = await repository.getPortfolio();

      emit(PortfolioLoaded(portfolio));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  /// Simulates a market refresh by updating holding prices.
  Future<void> refreshPortfolio() async {
    final currentState = state;
    if (currentState is PortfolioLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    try {
      final portfolio = await repository.refreshPortfolio();
      emit(PortfolioLoaded(portfolio));
    } catch (e) {
      if (currentState is PortfolioLoaded) {
        emit(currentState.copyWith(isRefreshing: false));
      }
      emit(PortfolioError(e.toString()));
    }
  }
}
