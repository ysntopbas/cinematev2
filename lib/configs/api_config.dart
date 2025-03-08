import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static final apiKey = dotenv.env['API_KEY'];
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
}
