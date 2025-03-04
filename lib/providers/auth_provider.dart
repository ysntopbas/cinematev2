import 'package:cinematev2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  AuthProvider() {
    _isAuthenticated = !(user == null);
  }

  bool get isAuthenticated => _isAuthenticated;
  User? user = FirebaseAuth.instance.currentUser;

  void login(String email, String password) async {
    final deneme = await _authService.login(email, password);
    if (deneme == null) {
      _isAuthenticated = false;
    } else {
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  void register(String email, String password) async {
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
