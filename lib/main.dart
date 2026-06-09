import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/preferences_service.dart';
import 'data/datasource/portfolio_local_datasource.dart';
import 'data/repository/portfolio_repository_impl.dart';
import 'presentation/app/app.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/dashboard/cubit/portfolio_cubit.dart';
import 'presentation/settings/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesService = await PreferencesService.init();
  final dataSource = PortfolioLocalDataSourceImpl();
  final repository = PortfolioRepositoryImpl(dataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(preferencesService),
        ),
        BlocProvider(
          create: (_) => AuthCubit(preferencesService)..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) => PortfolioCubit(repository),
        ),
      ],
      child: const FinViewApp(),
    ),
  );
}
