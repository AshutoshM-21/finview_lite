import 'package:shared_preferences/shared_preferences.dart';

/// Keys used for persisting user session and app preferences.
abstract final class PreferenceKeys {
  static const String isLoggedIn = 'is_logged_in';
  static const String userEmail = 'user_email';
  static const String isDarkMode = 'is_dark_mode';
}

/// Thin wrapper around [SharedPreferences] for auth and theme persistence.
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  bool get isLoggedIn => _prefs.getBool(PreferenceKeys.isLoggedIn) ?? false;

  String? get userEmail => _prefs.getString(PreferenceKeys.userEmail);

  bool get isDarkMode => _prefs.getBool(PreferenceKeys.isDarkMode) ?? false;

  Future<void> setLoggedIn({
    required bool value,
    String? email,
  }) async {
    await _prefs.setBool(PreferenceKeys.isLoggedIn, value);
    if (email != null) {
      await _prefs.setString(PreferenceKeys.userEmail, email);
    }
    if (!value) {
      await _prefs.remove(PreferenceKeys.userEmail);
    }
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(PreferenceKeys.isDarkMode, value);
  }
}
