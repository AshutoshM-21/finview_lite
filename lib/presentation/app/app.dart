import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/cubit/auth_state.dart';
import '../auth/screen/login_screen.dart';
import '../dashboard/cubit/portfolio_cubit.dart';
import '../dashboard/screen/dashboard_screen.dart';
import '../settings/cubit/theme_cubit.dart';

/// Root widget wiring auth, theme, and portfolio navigation.
class FinViewApp extends StatelessWidget {
  const FinViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FinView Lite',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const _AuthGate(),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<PortfolioCubit>().loadPortfolio();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AuthAuthenticated) {
            return const DashboardScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
