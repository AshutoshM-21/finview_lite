import 'package:equatable/equatable.dart';

import '../../../data/models/portfolio_model.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final PortfolioModel portfolio;
  final bool isRefreshing;

  const PortfolioLoaded(
    this.portfolio, {
    this.isRefreshing = false,
  });

  PortfolioLoaded copyWith({
    PortfolioModel? portfolio,
    bool? isRefreshing,
  }) {
    return PortfolioLoaded(
      portfolio ?? this.portfolio,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [portfolio, isRefreshing];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
