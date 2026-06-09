import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finview_lite/core/services/preferences_service.dart';
import 'package:finview_lite/data/models/holding_model.dart';
import 'package:finview_lite/data/models/portfolio_model.dart';
import 'package:finview_lite/data/repository/portfolio_repository.dart';
import 'package:finview_lite/presentation/auth/cubit/auth_cubit.dart';
import 'package:finview_lite/presentation/dashboard/cubit/portfolio_cubit.dart';
import 'package:finview_lite/presentation/dashboard/screen/dashboard_screen.dart';
import 'package:finview_lite/presentation/settings/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePortfolioRepository implements PortfolioRepository {
  @override
  Future<PortfolioModel> getPortfolio() async {
    return const PortfolioModel(
      user: 'Test User',
      holdings: [
        HoldingModel(
          symbol: 'TCS',
          name: 'Tata Consultancy',
          units: 5,
          avgCost: 3200,
          currentPrice: 3400,
        ),
      ],
    );
  }

  @override
  Future<PortfolioModel> refreshPortfolio() => getPortfolio();
}

Future<Widget> _buildDashboardApp() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await PreferencesService.init();

  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit(preferences)),
      BlocProvider(create: (_) => AuthCubit(preferences)),
      BlocProvider(
        create: (_) => PortfolioCubit(_FakePortfolioRepository())..loadPortfolio(),
      ),
    ],
    child: const MaterialApp(home: DashboardScreen()),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Dashboard shows portfolio summary when loaded',
      (WidgetTester tester) async {
    await tester.pumpWidget(await _buildDashboardApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Hello, Test User'), findsOneWidget);
    expect(find.text('Portfolio Value'), findsOneWidget);
    expect(find.text('Holdings'), findsOneWidget);
    expect(find.text('TCS'), findsOneWidget);
    expect(find.text('Asset Allocation'), findsOneWidget);
  });
}
