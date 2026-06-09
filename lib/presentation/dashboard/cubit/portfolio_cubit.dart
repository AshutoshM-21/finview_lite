import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/portfolio_repository.dart';
import 'portfolio_state.dart';

class PortfolioCubit
    extends Cubit<PortfolioState> {

  final PortfolioRepository repository;

  PortfolioCubit(this.repository)
      : super(
          PortfolioInitial(),
        );

  Future<void> loadPortfolio() async {
    try {
      emit(
        PortfolioLoading(),
      );

      final portfolio =
          await repository.getPortfolio();

      emit(
        PortfolioLoaded(
          portfolio,
        ),
      );
    } catch (e) {
      emit(
        PortfolioError(
          e.toString(),
        ),
      );
    }
  }
}