import 'dart:convert';
import 'dart:developer';
import 'package:cinematev2/models/tvshows_details_models.dart';
import 'package:http/http.dart' as http;
import 'package:cinematev2/configs/api_config.dart';
import 'package:cinematev2/models/tvshows_models.dart';

class TvshowService {
  Future<List<Tvshow>> fetchPopularTvshows({int page = 1}) async {
    try {
      final url = Uri.parse(
          "${ApiConfig.baseUrl}/tv/top_rated?api_key=${ApiConfig.apiKey}&language=tr-TR&page=$page&include_adult=false");

      log("API isteği yapılıyor: Sayfa $page");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("API yanıtı başarılı: ${response.statusCode}");
        return Tvshow.fromJsonList(response.body);
      } else {
        log("API hatası: ${response.statusCode} - ${response.body}");
        throw Exception(
            "Popüler diziler getirilemedi. Durum kodu: ${response.statusCode}");
      }
    } catch (e) {
      log("Dizi servisi hatası: $e");
      throw Exception("Popüler diziler getirilemedi: $e");
    }
  }

  Future<TvshowsDetailsModels> fetchDetailMovies(int tvshowId) async {
    try {
      final url = Uri.parse(
          "${ApiConfig.baseUrl}/tv/$tvshowId?api_key=${ApiConfig.apiKey}&language=tr-TR");

      log("API isteği yapılıyor: Film ID $tvshowId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("API yanıtı başarılı: ${response.statusCode}");

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        return TvshowsDetailsModels.fromJson(jsonData);
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
