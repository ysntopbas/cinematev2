import 'dart:convert';

import 'package:cinematev2/configs/api_config.dart';
import 'package:cinematev2/models/movie_details_models.dart';
import 'package:cinematev2/models/movie_models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class MovieService {
  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    try {
      final url = Uri.parse(
          "${ApiConfig.baseUrl}/movie/top_rated?api_key=${ApiConfig.apiKey}&language=tr-TR&page=$page&include_adult=false");

      log("API isteği yapılıyor: Sayfa $page");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("API yanıtı başarılı: ${response.statusCode}");
        return Movie.fromJsonList(response.body);
      } else {
        log("API hatası: ${response.statusCode} - ${response.body}");
        throw Exception(
            "Popüler filmler getirilemedi. Durum kodu: ${response.statusCode}");
      }
    } catch (e) {
      log("Film servisi hatası: $e");
      throw Exception("Popüler filmler getirilemedi: $e");
    }
  }

  Future<MovieDetailsModels> fetchDetailMovies(int movieId) async {
    try {
      final url = Uri.parse(
          "${ApiConfig.baseUrl}/movie/$movieId?api_key=${ApiConfig.apiKey}&language=tr-TR");

      log("API isteği yapılıyor: Film ID $movieId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("API yanıtı başarılı: ${response.statusCode}");

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        return MovieDetailsModels.fromJson(jsonData);
      } else {
        log("API hatası: ${response.statusCode} - ${response.body}");
        throw Exception(
            "Film detayları getirilemedi. Durum kodu: ${response.statusCode}");
      }
    } catch (e) {
      log("Film servisi hatası: $e");
      throw Exception("Film detayları getirilemedi: $e");
    }
  }
}
