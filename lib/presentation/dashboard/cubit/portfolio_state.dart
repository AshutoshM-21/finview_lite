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
  final DateTime lastUpdated;

  PortfolioLoaded(
    this.portfolio, {
    this.isRefreshing = false,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  PortfolioLoaded copyWith({
    PortfolioModel? portfolio,
    bool? isRefreshing,
    DateTime? lastUpdated,
  }) {
    return PortfolioLoaded(
      portfolio ?? this.portfolio,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [portfolio, isRefreshing, lastUpdated];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
