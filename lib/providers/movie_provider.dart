import 'package:cinematev2/models/movie_models.dart';
import 'package:cinematev2/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _popularMovies = [];
  bool _isLoading = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  String? _error;

  List<Movie> get popularMovies => _popularMovies;
  bool get isLoading => _isLoading;
  bool get hasMorePages => _hasMorePages;
  String? get error => _error;

  Future<void> fetchPopularMovies({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _currentPage = 1;
      _popularMovies = [];
      _hasMorePages = true;
    }
    
    if (!_hasMorePages && !refresh) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      log("Popüler filmler getiriliyor... Sayfa: $_currentPage");
      final movies = await _movieService.fetchPopularMovies(page: _currentPage);
      
      if (movies.isEmpty) {
        _hasMorePages = false;
      } else {
        _popularMovies.addAll(movies);
        _currentPage++;
      }
      
      log("${movies.length} film başarıyla getirildi. Toplam: ${_popularMovies.length}");
    } catch (e) {
      log("Film getirme hatası: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void resetPagination() {
    _currentPage = 1;
    _popularMovies = [];
    _hasMorePages = true;
    _error = null;
    notifyListeners();
  }
} 