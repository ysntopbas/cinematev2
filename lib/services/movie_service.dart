import 'package:cinematev2/configs/api_config.dart';
import 'package:cinematev2/models/movie_models.dart';
import 'package:http/http.dart' as http;

class MovieService {
  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse(
        "${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}&language=tr-TR&page=1&include_adult=false");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Movie.fromJsonList(response.body);
    } else {
      throw Exception("Popüler filmler getirilemedi.");
    }
  }
}
