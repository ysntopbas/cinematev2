import 'dart:developer';
import 'package:cinematev2/models/movie_models.dart';
import 'package:cinematev2/models/tvshows_models.dart';
import 'package:cinematev2/services/movie_service.dart';
import 'package:cinematev2/services/tvshow_service.dart';
import 'package:cinematev2/services/watch_list_service.dart';
import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  final WatchListService _watchListService = WatchListService();
  final MovieService _movieService = MovieService();
  final TvshowService _tvshowService = TvshowService();

  List<Movie> _watchListMovies = [];
  List<Tvshow> _watchListTvshows = [];
  bool _isLoading = false;
  String? _error;

  List<Movie> get watchListMovies => _watchListMovies;
  List<Tvshow> get watchListTvshows => _watchListTvshows;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWatchLists() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Paralel olarak her iki listeyi de çek
      await Future.wait([
        _fetchMovieWatchList(),
        _fetchTvshowWatchList(),
      ]);

      log('İzleme listeleri başarıyla çekildi. Filmler: ${_watchListMovies.length}, Diziler: ${_watchListTvshows.length}');
    } catch (e) {
      log('İzleme listeleri çekilirken hata: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchMovieWatchList() async {
    try {
      final movieWatchList = await _watchListService.getFetchWatchList('movie');
      _watchListMovies = [];

      // Sınırlı sayıda eşzamanlı istek (maksimum 3)
      for (int i = 0; i < movieWatchList.length; i += 3) {
        final batch = movieWatchList.skip(i).take(3);
        final futures = batch.map((movie) => _fetchSingleMovie(movie)).toList();
        await Future.wait(futures);
      }
    } catch (e) {
      log('Film izleme listesi yüklenirken hata: $e');
    }
  }

  Future<void> _fetchSingleMovie(Map<String, dynamic> movie) async {
    try {
      final movieId = int.parse(movie['id']);
      final movieDetails = await _movieService.fetchDetailMovies(movieId);
      movieDetails.isAdded = true;
      _watchListMovies.add(movieDetails);
    } catch (e) {
      log('Film detayları çekilirken hata: $e');
    }
  }

  Future<void> _fetchTvshowWatchList() async {
    try {
      final tvshowWatchList =
          await _watchListService.getFetchWatchList('series');
      _watchListTvshows = [];

      // Sınırlı sayıda eşzamanlı istek (maksimum 3)
      for (int i = 0; i < tvshowWatchList.length; i += 3) {
        final batch = tvshowWatchList.skip(i).take(3);
        final futures =
            batch.map((tvshow) => _fetchSingleTvshow(tvshow)).toList();
        await Future.wait(futures);
      }
    } catch (e) {
      log('Dizi izleme listesi yüklenirken hata: $e');
    }
  }

  Future<void> _fetchSingleTvshow(Map<String, dynamic> tvshow) async {
    try {
      final tvshowId = int.parse(tvshow['id']);
      final tvshowDetails = await _tvshowService.fetchDetailMovies(tvshowId);
      tvshowDetails.isAdded = true;
      _watchListTvshows.add(tvshowDetails);
    } catch (e) {
      log('Dizi detayları çekilirken hata: $e');
    }
  }

  Future<void> removeMovieFromWatchList(int movieId) async {
    try {
      await _watchListService.removeFromWatchList(movieId, 'movie');
      _watchListMovies.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
      log('Film izleme listesinden kaldırıldı: $movieId');
    } catch (e) {
      log('Film izleme listesinden kaldırılırken hata: $e');
      rethrow;
    }
  }

  Future<void> removeTvshowFromWatchList(int tvshowId) async {
    try {
      await _watchListService.removeFromWatchList(tvshowId, 'series');
      _watchListTvshows.removeWhere((tvshow) => tvshow.id == tvshowId);
      notifyListeners();
      log('Dizi izleme listesinden kaldırıldı: $tvshowId');
    } catch (e) {
      log('Dizi izleme listesinden kaldırılırken hata: $e');
      rethrow;
    }
  }
}
