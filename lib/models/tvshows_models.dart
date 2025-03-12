import 'dart:convert';
import 'dart:developer';

import 'package:cinematev2/models/content_models.dart';

class Tvshow extends Content {
  Tvshow({
    required super.id,
    required super.title,
    required super.posterPath,
  });
  factory Tvshow.fromJson(Map<String, dynamic> json) {
    return Tvshow(
      id: json['id'] ?? 0,
      title: json['name'] ?? 'İsimsiz Dizi',
      posterPath: json['poster_path'] ?? '',
    );
  }
  static List<Tvshow> fromJsonList(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      if (data['results'] == null) {
        log("API yanıtında 'results' alanı bulunamadı");
        return [];
      }

      return (data['results'] as List)
          .map((tvshow) => Tvshow.fromJson(tvshow))
          .toList();
    } catch (e) {
      log("JSON ayrıştırma hatası: $e");
      log("JSON içeriği: $jsonString");
      return [];
    }
  }
}
