import 'dart:developer';
import 'package:cinematev2/models/tvshows_models.dart';
import 'package:cinematev2/services/tvshow_service.dart';
import 'package:cinematev2/services/watch_list_service.dart';
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
    } catch (e) {
      log("Dizi getirme hatası: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTvshowWatchList(int tvshowId, String title) async {
    try {
      await _watchListService.addToWatchList(tvshowId, title, 'series');
    } catch (e) {
      log('addTvshowWatchList error: $e');
    }
  }

  Future<void> removeTvshowWatchList(int tvshowId) async {
    try {
      await _watchListService.removeFromWatchList(tvshowId, 'series');
    } catch (e) {
      log('removeTvshowWatchList error: $e');
    }
  }

  void resetPagination() {
    _currentPage = 1;
    _popularTvshows = [];
    _hasMorePages = true;
    _error = null;
    notifyListeners();
  }
}
