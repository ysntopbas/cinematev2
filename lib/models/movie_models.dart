import 'dart:convert';

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
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
    );
  }

  static List<Movie> fromJsonList(String jsonString) {
    final data = jsonDecode(jsonString);
    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }
}
