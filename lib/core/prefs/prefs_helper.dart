import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static final PrefsHelper instance = PrefsHelper._init();
  static SharedPreferences? _prefs;

  PrefsHelper._init();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _isDarkThemeKey = 'is_dark_theme';

  // Token
  Future<void> setToken(String token) async {
    final p = await prefs;
    await p.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final p = await prefs;
    return p.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final p = await prefs;
    await p.remove(_tokenKey);
  }

  // Theme
  Future<void> setDarkTheme(bool isDark) async {
    final p = await prefs;
    await p.setBool(_isDarkThemeKey, isDark);
  }

  Future<bool> isDarkTheme() async {
    final p = await prefs;
    return p.getBool(_isDarkThemeKey) ?? false;
  }
}
