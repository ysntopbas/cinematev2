import 'package:cinematev2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ai_recommendations_provider.dart';
import 'favorite_provider.dart';
import 'movie_provider.dart';
import 'tvshow_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  User? _user;
  User? get user => _user;

  AiRecommendationsProvider? _aiProvider;
  FavoriteProvider? _favoriteProvider;
  MovieProvider? _movieProvider;
  TvshowProvider? _tvshowProvider;

  void setAiProvider(AiRecommendationsProvider aiProvider) {
    _aiProvider = aiProvider;
  }

  void setFavoriteProvider(FavoriteProvider favoriteProvider) {
    _favoriteProvider = favoriteProvider;
  }

  void setMovieProvider(MovieProvider movieProvider) {
    _movieProvider = movieProvider;
  }

  void setTvshowProvider(TvshowProvider tvshowProvider) {
    _tvshowProvider = tvshowProvider;
  }

  AuthProvider() {
    _authService.user.listen((User? user) {
      final previousUser = _user;
      _user = user;

      if (user == null) {
        _isAuthenticated = false;
        // Kullanıcı çıkış yaptığında tüm verilerini temizle
        _aiProvider?.clearAllData();
        _favoriteProvider?.clearAllData();
        _movieProvider?.clearCache();
        _tvshowProvider?.clearCache();
      } else {
        _isAuthenticated = true;
        // Farklı bir kullanıcı giriş yaptığında tüm verilerini temizle
        if (previousUser != null && previousUser.uid != user.uid) {
          _aiProvider?.clearAllData();
          _favoriteProvider?.clearAllData();
          _movieProvider?.clearCache();
          _tvshowProvider?.clearCache();
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
      // Çıkış yapıldığında tüm verilerini temizle
      _aiProvider?.clearAllData();
      _favoriteProvider?.clearAllData();
      _movieProvider?.clearCache();
      _tvshowProvider?.clearCache();
      notifyListeners();
    }
  }
}
