import 'package:cinematev2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ai_recommendations_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  User? _user;
  User? get user => _user;

  AiRecommendationsProvider? _aiProvider;

  void setAiProvider(AiRecommendationsProvider aiProvider) {
    _aiProvider = aiProvider;
  }

  AuthProvider() {
    _authService.user.listen((User? user) {
      final previousUser = this._user;
      this._user = user;

      if (user == null) {
        _isAuthenticated = false;
        // Kullanıcı çıkış yaptığında AI verilerini temizle
        _aiProvider?.clearAllData();
      } else {
        _isAuthenticated = true;
        // Farklı bir kullanıcı giriş yaptığında AI verilerini temizle
        if (previousUser != null && previousUser.uid != user.uid) {
          _aiProvider?.clearAllData();
        }
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
      // Çıkış yapıldığında AI verilerini temizle
      _aiProvider?.clearAllData();
      notifyListeners();
    }
  }
}
