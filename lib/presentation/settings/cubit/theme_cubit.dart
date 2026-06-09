import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/preferences_service.dart';

/// Manages light/dark theme with persistence via [PreferencesService].
class ThemeCubit extends Cubit<bool> {
  final PreferencesService preferencesService;

  ThemeCubit(this.preferencesService) : super(preferencesService.isDarkMode);

  Future<void> toggleTheme() async {
    final nextValue = !state;
    await preferencesService.setDarkMode(nextValue);
    emit(nextValue);
  }
}
