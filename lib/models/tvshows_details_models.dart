import 'dart:convert';
import 'dart:developer';

import 'package:cinematev2/models/tvshows_models.dart';

class TvshowsDetailsModels extends Tvshow {
  final String? backdropPath;
  final String? originalLanguage;
  final String? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final String? tagline;
  final String? originalName;
  final String? overview;
  final List<dynamic>? genres;
  final String? status;
  final int? numberofEpisodes;
  final int? numberofSeasons;

  TvshowsDetailsModels({
    required super.id,
    required super.title,
    required super.posterPath,
    required this.backdropPath,
    required this.originalLanguage,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.tagline,
    required this.originalName,
    required this.overview,
    required this.genres,
    required this.status,
    required this.numberofEpisodes,
    required this.numberofSeasons,
  });

  factory TvshowsDetailsModels.fromJson(Map<String, dynamic> json) {
    return TvshowsDetailsModels(
      id: json['id'] ?? 0,
      title: json['name'] ?? 'İsimsiz Dizi',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      tagline: json['tagline'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      genres: json['genres'] ?? [],
      status: json['status'] ?? '',
      numberofEpisodes: json['number_of_episodes'] ?? 0,
      numberofSeasons: json['number_of_seasons'] ?? 0,
    );
  }

  static List<TvshowsDetailsModels> fromJsonList(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      if (data['results'] == null) {
        log("API yanıtında 'results' alanı bulunamadı");
        return [];
      }
      return (data['results'] as List)
          .map((tvshow) => TvshowsDetailsModels.fromJson(tvshow))
          .toList();
    } catch (e) {
      log("JSON ayrıştırma hatası: $e");
      return [];
    }
  }

  String getGenresAsString() {
    if (genres == null || genres!.isEmpty) return '';
    return genres!.map((genre) => genre['name']).join(', ');
  }
}
