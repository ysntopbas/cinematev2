import 'package:cinematev2/models/movie_models.dart';
import 'package:cinematev2/services/movie_service.dart';
import 'package:cinematev2/services/watch_list_service.dart';
import 'package:cinematev2/services/favorite_service.dart';
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
  final WatchListService _watchListService = WatchListService();
  final FavoriteService _favoriteService = FavoriteService();

  // Favori durumları için cache
  final Map<int, bool> _favoriteStatus = {};
  bool _favoritesLoaded = false;

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

      // İzleme listesi durumunu güncelle
      await updateWatchListStatus();

      // Favori durumlarını sadece ilk seferde yükle
      if (!_favoritesLoaded) {
        await loadFavoriteStatuses();
        _favoritesLoaded = true;
      } else {
        // Sadece yeni eklenen filmler için favori durumunu kontrol et
        await loadFavoriteStatusesForNewMovies(movies);
      }
    } catch (e) {
      log("Film getirme hatası: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMovieWatchList(int movieId, String title) async {
    try {
      await _watchListService.addToWatchList(movieId, title, 'movie');

      final index = _popularMovies.indexWhere((movie) => movie.id == movieId);
      if (index != -1) {
        _popularMovies[index].isAdded = true;
        notifyListeners();
      }

      log("Film izleme listesine eklendi.");
    } catch (e) {
      log("Film izleme listesine eklerken hata: $e");
      rethrow;
    }
  }

  Future<void> removeMovieWatchList(int movieId) async {
    try {
      await _watchListService.removeFromWatchList(movieId, 'movie');

      final index = _popularMovies.indexWhere((movie) => movie.id == movieId);
      if (index != -1) {
        _popularMovies[index].isAdded = false;
        notifyListeners();
      }

      log("Film izleme listesinden silindi.");
    } catch (e) {
      log("Film izleme listesinden silerken hata: $e");
      rethrow;
    }
  }

  void resetPagination() {
    _currentPage = 1;
    _popularMovies = [];
    _hasMorePages = true;
    _error = null;
    notifyListeners();
  }

  Future<void> updateWatchListStatus() async {
    try {
      final watchList = await _watchListService.getFetchWatchList('movie');

      for (var movie in _popularMovies) {
        movie.isAdded = watchList
            .any((item) => item['id'].toString() == movie.id.toString());
      }

      notifyListeners();
    } catch (e) {
      log("İzleme listesi durumu güncellenirken hata: $e");
    }
  }

  // Favori durumunu kontrol et
  bool isFavorite(int id) {
    return _favoriteStatus[id] ?? false;
  }

  // Favori toggle
  Future<void> toggleFavorite(
      int id, String title, String type, String posterPath) async {
    try {
      final currentStatus = _favoriteStatus[id] ?? false;

      if (currentStatus) {
        await _favoriteService.removeFromFavorites(id);
        _favoriteStatus[id] = false;
        log("Film favorilerden çıkarıldı: $title");
      } else {
        await _favoriteService.addToFavorites(id, title, type, posterPath);
        _favoriteStatus[id] = true;
        log("Film favorilere eklendi: $title");
      }

      notifyListeners();
    } catch (e) {
      log("Favori toggle işleminde hata: $e");
    }
  }

  // Favori durumlarını yükle (optimize edilmiş)
  Future<void> loadFavoriteStatuses() async {
    try {
      // Tüm favori ID'lerini bir seferde getir
      final favoriteIds = await _favoriteService.getAllFavoriteIds();

      // Mevcut filmlerin favori durumlarını güncelle
      for (var movie in _popularMovies) {
        _favoriteStatus[movie.id] = favoriteIds.contains(movie.id);
      }

      notifyListeners();
      log("${favoriteIds.length} favori durum güncellendi");
    } catch (e) {
      log("Favori durumları yüklenirken hata: $e");
    }
  }

  // Sadece yeni eklenen filmler için favori durumunu kontrol et
  Future<void> loadFavoriteStatusesForNewMovies(List<Movie> newMovies) async {
    try {
      final favoriteIds = await _favoriteService.getAllFavoriteIds();

      for (var movie in newMovies) {
        _favoriteStatus[movie.id] = favoriteIds.contains(movie.id);
      }

      notifyListeners();
      log("${newMovies.length} yeni film için favori durum kontrol edildi");
    } catch (e) {
      log("Yeni filmler için favori durumları yüklenirken hata: $e");
    }
  }

  // Kullanıcı değiştiğinde cache'leri temizle
  void clearCache() {
    _favoriteStatus.clear();
    _favoritesLoaded = false;
    notifyListeners();
  }
}
