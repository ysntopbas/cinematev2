import 'dart:developer';
import 'package:cinematev2/models/tvshows_models.dart';
import 'package:cinematev2/services/tvshow_service.dart';
import 'package:cinematev2/services/watch_list_service.dart';
import 'package:cinematev2/services/favorite_service.dart';
import 'package:flutter/material.dart';

class TvshowProvider extends ChangeNotifier {
  final TvshowService _tvshowService = TvshowService();
  List<Tvshow> _popularTvshows = [];
  bool _isLoading = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  String? _error;

  List<Tvshow> get popularTvshows => _popularTvshows;
  bool get isLoading => _isLoading;
  bool get hasMorePages => _hasMorePages;
  String? get error => _error;
  final WatchListService _watchListService = WatchListService();
  final FavoriteService _favoriteService = FavoriteService();

  // Favori durumları için cache
  final Map<int, bool> _favoriteStatus = {};
  bool _favoritesLoaded = false;

  Future<void> fetchPopularTvshows({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _popularTvshows = [];
      _hasMorePages = true;
    }

    if (!_hasMorePages && !refresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      log("Popüler diziler getiriliyor... Sayfa: $_currentPage");
      final tvshows =
          await _tvshowService.fetchPopularTvshows(page: _currentPage);

      if (tvshows.isEmpty) {
        _hasMorePages = false;
      } else {
        _popularTvshows.addAll(tvshows);
        _currentPage++;
      }

      log("${tvshows.length} dizi başarıyla getirildi. Toplam: ${_popularTvshows.length}");

      // İzleme listesi durumunu güncelle
      await updateWatchListStatus();

      // Favori durumlarını sadece ilk seferde yükle
      if (!_favoritesLoaded) {
        await loadFavoriteStatuses();
        _favoritesLoaded = true;
      } else {
        // Sadece yeni eklenen diziler için favori durumunu kontrol et
        await loadFavoriteStatusesForNewTvshows(tvshows);
      }
    } catch (e) {
      log("Dizi getirme hatası: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTvShowWatchList(int tvshowId, String title) async {
    try {
      await _watchListService.addToWatchList(tvshowId, title, 'series');

      // İzleme listesine eklenen dizinin durumunu güncelle
      final index =
          _popularTvshows.indexWhere((tvshow) => tvshow.id == tvshowId);
      if (index != -1) {
        _popularTvshows[index].isAdded = true;
        notifyListeners();
      }

      log("Dizi izleme listesine eklendi.");
    } catch (e) {
      log("Dizi izleme listesine eklerken hata: $e");
      rethrow;
    }
  }

  Future<void> removeTvShowWatchList(int tvshowId) async {
    try {
      await _watchListService.removeFromWatchList(tvshowId, 'series');

      // İzleme listesinden çıkarılan dizinin durumunu güncelle
      final index =
          _popularTvshows.indexWhere((tvshow) => tvshow.id == tvshowId);
      if (index != -1) {
        _popularTvshows[index].isAdded = false;
        notifyListeners();
      }

      log("Dizi izleme listesinden silindi.");
    } catch (e) {
      log("Dizi izleme listesinden silerken hata: $e");
      rethrow;
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
        log("Dizi favorilerden çıkarıldı: $title");
      } else {
        await _favoriteService.addToFavorites(id, title, type, posterPath);
        _favoriteStatus[id] = true;
        log("Dizi favorilere eklendi: $title");
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

      // Mevcut dizilerin favori durumlarını güncelle
      for (var tvshow in _popularTvshows) {
        _favoriteStatus[tvshow.id] = favoriteIds.contains(tvshow.id);
      }

      notifyListeners();
      log("${favoriteIds.length} favori durum güncellendi");
    } catch (e) {
      log("Favori durumları yüklenirken hata: $e");
    }
  }

  // Sadece yeni eklenen diziler için favori durumunu kontrol et
  Future<void> loadFavoriteStatusesForNewTvshows(
      List<Tvshow> newTvshows) async {
    try {
      final favoriteIds = await _favoriteService.getAllFavoriteIds();

      for (var tvshow in newTvshows) {
        _favoriteStatus[tvshow.id] = favoriteIds.contains(tvshow.id);
      }

      notifyListeners();
      log("${newTvshows.length} yeni dizi için favori durum kontrol edildi");
    } catch (e) {
      log("Yeni diziler için favori durumları yüklenirken hata: $e");
    }
  }

  void resetPagination() {
    _currentPage = 1;
    _popularTvshows = [];
    _hasMorePages = true;
    _error = null;
    notifyListeners();
  }

  Future<void> updateWatchListStatus() async {
    try {
      final watchList = await _watchListService.getFetchWatchList('series');

      for (var tvshow in _popularTvshows) {
        tvshow.isAdded = watchList
            .any((item) => item['id'].toString() == tvshow.id.toString());
      }

      notifyListeners();
    } catch (e) {
      log("İzleme listesi durumu güncellenirken hata: $e");
    }
  }

  // Kullanıcı değiştiğinde cache'leri temizle
  void clearCache() {
    _favoriteStatus.clear();
    _favoritesLoaded = false;
    notifyListeners();
  }
}
