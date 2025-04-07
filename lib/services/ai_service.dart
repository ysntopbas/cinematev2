import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-thinking-exp-01-21:generateContent';

  Future<Map<String, dynamic>> getRecommendations(
      List<String> watchlist) async {
    try {
      final requestBody = {
        'generationConfig': {
          'temperature': 0.7,
          'topP': 0.95,
          'topK': 64,
          'maxOutputTokens': 65536,
          'responseMimeType': 'text/plain',
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': watchlist.join(', '),
              },
            ],
          },
        ],
        'systemInstruction': {
          'role': 'user',
          'parts': [
            {
              'text':
                  'Review the list of movies and TV shows I\'ve sent you. Suggest 3 movies and 3 TV shows for someone who has watched and liked those. The response should be in JSON format only and include just the names of the movies and shows.If any of the suggested titles have official Turkish names, provide those instead of the English titles.',
            },
          ],
        },
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('AI servisi yanıt vermedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('AI servisi hatası: $e');
    }
  }
}
