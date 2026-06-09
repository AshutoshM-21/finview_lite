import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'data/datasource/portfolio_local_datasource.dart';
import 'data/repository/portfolio_repository.dart';
import 'presentation/dashboard/cubit/portfolio_cubit.dart';
import 'presentation/dashboard/screen/dashboard_screen.dart';

void main() {
  final datasource = PortfolioLocalDataSourceImpl();
  final repository = PortfolioRepositoryImpl(datasource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PortfolioRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PortfolioCubit(repository)..loadPortfolio(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FinView Lite',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            surface: AppColors.cardBackground,
          ),
          cardTheme: CardThemeData(
            color: AppColors.cardBackground,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
