import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> loadAuthState() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = await _repository.isLoggedIn();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.login(username, password);
    _isAuthenticated = result;

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await _repository.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
