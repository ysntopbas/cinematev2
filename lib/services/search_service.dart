import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinematev2/configs/api_config.dart';

class SearchService {
  Future<Map<String, dynamic>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/search/movie?api_key=${ApiConfig.apiKey}&query=${Uri.encodeComponent(query)}&language=tr-TR',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Film arama hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Film arama hatası: $e');
    }
  }

  Future<Map<String, dynamic>> searchTvShows(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/search/tv?api_key=${ApiConfig.apiKey}&query=${Uri.encodeComponent(query)}&language=tr-TR',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Dizi arama hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Dizi arama hatası: $e');
    }
  }
}
