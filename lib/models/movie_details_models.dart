import 'dart:convert';
import 'dart:developer';

import 'package:cinematev2/models/movie_models.dart';

class MovieDetailsModels extends Movie {
  final String? backdropPath;
  final String? releaseDate;
  final List<dynamic>? genres;
  final String? homepage;
  final String? lastAirDate;
  final int? numberofEpisodes;
  final int? numberofSeasons;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? voteAverage;
  final int? voteCount;
  final String? tagline;
  final String? status;

  MovieDetailsModels({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.isAdded,
    required this.backdropPath,
    required this.releaseDate,
    required this.genres,
    required this.homepage,
    required this.lastAirDate,
    required this.numberofEpisodes,
    required this.numberofSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.tagline,
    required this.status,
  });

  factory MovieDetailsModels.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModels(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'İsimsiz Film',
      posterPath: json['poster_path'] ?? '',
      isAdded: false,
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genres: json['genres'] ?? [],
      homepage: json['homepage'] ?? '',
      lastAirDate: json['last_air_date'] ?? '',
      numberofEpisodes: json['number_of_episodes'] ?? 0,
      numberofSeasons: json['number_of_seasons'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      tagline: json['tagline'] ?? '',
      status: json['status'] ?? '',
    );
  }

  static List<MovieDetailsModels> fromJsonList(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      if (data['results'] == null) {
        log("API yanıtında 'results' alanı bulunamadı");
        return [];
      }
      return (data['results'] as List)
          .map((movie) => MovieDetailsModels.fromJson(movie))
          .toList();
    } catch (e) {
      log("JSON ayrıştırma hatası: $e");
      log("JSON içeriği: $jsonString");
      return [];
    }
  }

  String getGenresAsString() {
    if (genres == null || genres!.isEmpty) return '';
    return genres!.map((genre) => genre['name']).join(', ');
  }
}
