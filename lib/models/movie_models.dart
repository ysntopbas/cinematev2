import 'dart:convert';
import 'dart:developer';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
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
