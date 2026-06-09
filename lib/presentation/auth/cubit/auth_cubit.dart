import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/preferences_service.dart';
import 'auth_state.dart';

/// Mock authentication with session persistence through SharedPreferences.
class AuthCubit extends Cubit<AuthState> {
  final PreferencesService preferencesService;

  AuthCubit(this.preferencesService) : super(AuthInitial());

  /// Restores session on app launch.
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    if (preferencesService.isLoggedIn) {
      emit(AuthAuthenticated(preferencesService.userEmail ?? 'user@finview.app'));
      return;
    }

    emit(AuthUnauthenticated());
  }

  /// Accepts any non-empty credentials for demo purposes.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      emit(const AuthFailure('Email and password are required'));
      emit(AuthUnauthenticated());
      return;
    }

    if (!trimmedEmail.contains('@')) {
      emit(const AuthFailure('Enter a valid email address'));
      emit(AuthUnauthenticated());
      return;
    }

    emit(AuthLoading());

    await preferencesService.setLoggedIn(
      value: true,
      email: trimmedEmail,
    );

    emit(AuthAuthenticated(trimmedEmail));
  }

  Future<void> logout() async {
    await preferencesService.setLoggedIn(value: false);
    emit(AuthUnauthenticated());
  }
}
