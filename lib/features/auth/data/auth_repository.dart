import '../../../core/prefs/prefs_helper.dart';

class AuthRepository {
  final PrefsHelper _prefs = PrefsHelper.instance;

  Future<bool> login(String username, String password) async {
    // Mock login logic: Siempre accederá de momento para facilitar la visualización de la UI
    await _prefs.setToken('mock_token_12345');
    return true;
  }

  Future<void> logout() async {
    await _prefs.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _prefs.getToken();
    return token != null && token.isNotEmpty;
  }
}

