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
      // Film izleme listesini çek
      final movieWatchList = await _watchListService.getFetchWatchList('movie');
      _watchListMovies = [];

      // Her film için detayları çek
      for (var movie in movieWatchList) {
        try {
          final movieId = int.parse(movie['id']);
          final movieDetails = await _movieService.fetchDetailMovies(movieId);
          
          // İzleme listesinde olduğunu işaretle
          movieDetails.isAdded = true;
          _watchListMovies.add(movieDetails);
        } catch (e) {
          log('Film detayları çekilirken hata: $e');
        }
      }

      // Dizi izleme listesini çek
      final tvshowWatchList = await _watchListService.getFetchWatchList('series');
      _watchListTvshows = [];

      // Her dizi için detayları çek
      for (var tvshow in tvshowWatchList) {
        try {
          final tvshowId = int.parse(tvshow['id']);
          final tvshowDetails = await _tvshowService.fetchDetailMovies(tvshowId);
          
          // İzleme listesinde olduğunu işaretle
          tvshowDetails.isAdded = true;
          _watchListTvshows.add(tvshowDetails);
        } catch (e) {
          log('Dizi detayları çekilirken hata: $e');
        }
      }

      log('İzleme listeleri başarıyla çekildi. Filmler: ${_watchListMovies.length}, Diziler: ${_watchListTvshows.length}');
    } catch (e) {
      log('İzleme listeleri çekilirken hata: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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
