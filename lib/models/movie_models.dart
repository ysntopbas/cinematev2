import 'dart:convert';
import 'dart:developer';

import 'package:cinematev2/models/content_models.dart';

class Movie extends Content {
  Movie({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'İsimsiz Film',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
    );
  }
  static List<Movie> fromJsonList(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      if (data['results'] == null) {
        log("API yanıtında 'results' alanı bulunamadı");
        return [];
      }

      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } catch (e) {
      log("JSON ayrıştırma hatası: $e");
      log("JSON içeriği: $jsonString");
      return [];
    }
  }
}
