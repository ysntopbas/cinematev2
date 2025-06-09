import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../services/ai_recommendations_service.dart';

class AiRecommendationsProvider with ChangeNotifier {
  final AiRecommendationsService _recommendationsService =
      AiRecommendationsService();

  Map<String, dynamic>? _recommendations;
  final Map<String, bool> _watchedItems = {};
  bool _isLoading = false;
  bool _showRecommendations = false;

  Map<String, dynamic>? get recommendations => _recommendations;
  Map<String, bool> get watchedItems => _watchedItems;
  bool get isLoading => _isLoading;
  bool get showRecommendations => _showRecommendations;

  bool get canGetNewRecommendations {
    if (!_showRecommendations) return true;
    return _watchedItems.values.every((watched) => watched);
  }

  void setRecommendations(Map<String, dynamic> recommendations) {
    _recommendations = recommendations;
    _showRecommendations = true;
    _isLoading = false;
    _initializeWatchedItems();

    // Yeni önerileri Firebase'e kaydet
    _recommendationsService.saveUserRecommendations(recommendations);

    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _watchedItems.clear();
    }
    notifyListeners();
  }

  void toggleWatched(String item) {
    _watchedItems[item] = !(_watchedItems[item] ?? false);

    // İzleme durumunu Firebase'e kaydet
    _recommendationsService.updateWatchedStatus(_watchedItems);

    notifyListeners();
  }

  Future<void> resetRecommendations() async {
    _recommendations = null;
    _showRecommendations = false;
    _watchedItems.clear();

    // Firebase'den önerileri temizle
    await _recommendationsService.clearUserRecommendations();

    notifyListeners();
  }

  // Kullanıcının Firebase'deki önerilerini yükle
  Future<void> loadUserRecommendations() async {
    try {
      final savedData = await _recommendationsService.getUserRecommendations();

      if (savedData != null) {
        _recommendations = savedData['recommendations'];
        _showRecommendations = true;

        // Kayıtlı izleme durumlarını yükle
        final savedWatchedItems =
            Map<String, bool>.from(savedData['watchedItems'] ?? {});
        _watchedItems.clear();
        _watchedItems.addAll(savedWatchedItems);

        _initializeWatchedItems();
        notifyListeners();
      }
    } catch (e) {
      log('Kullanıcı önerileri yüklenirken hata: $e');
    }
  }

  // Kullanıcının önerileri olup olmadığını kontrol et
  Future<bool> hasUserRecommendations() async {
    try {
      return await _recommendationsService.hasUserRecommendations();
    } catch (e) {
      log('Öneri kontrolü yapılırken hata: $e');
      return false;
    }
  }

  // Kullanıcı değiştiğinde tüm verileri temizle
  void clearAllData() {
    _recommendations = null;
    _showRecommendations = false;
    _watchedItems.clear();
    _isLoading = false;
    notifyListeners();
  }

  void _initializeWatchedItems() {
    if (_recommendations == null) return;

    try {
      final response =
          _recommendations!['candidates'][0]['content']['parts'][0]['text'];
      final cleanJson =
          response.replaceAll('```json\n', '').replaceAll('\n```', '');
      final recommendations = jsonDecode(cleanJson);

      // Filmler için izleme durumlarını başlat
      for (final movie in List<String>.from(recommendations['movies'])) {
        if (!_watchedItems.containsKey(movie)) {
          _watchedItems[movie] = false;
        }
      }

      // Diziler için izleme durumlarını başlat
      for (final show in List<String>.from(recommendations['tv_shows'])) {
        if (!_watchedItems.containsKey(show)) {
          _watchedItems[show] = false;
        }
      }
    } catch (e) {
      log("$e");
    }
  }
}
