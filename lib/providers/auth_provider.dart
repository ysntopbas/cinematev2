import 'package:cinematev2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  User? user;

  AuthProvider() {
    _authService.user.listen((User? user) {
      this.user = user;
      if (user == null) {
        _isAuthenticated = false;
      } else {
        _isAuthenticated = true;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    final deneme = await _authService.login(email, password);
    if (deneme == null) {
      _isAuthenticated = false;
    } else {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    final kayit = await _authService.register(email, password);
    if (kayit == null) {
      _isAuthenticated = false;
    } else {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  void logout() {
    if (_isAuthenticated) {
      _authService.logout();
      _isAuthenticated = false;
      notifyListeners();
    }
  }
}
