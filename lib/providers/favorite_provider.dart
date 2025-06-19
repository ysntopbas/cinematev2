import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../services/favorite_service.dart';
import '../models/favorite_model.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();

  List<FavoriteItem> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Favori durumlarını tutmak için cache
  final Map<int, bool> _favoriteStatus = {};

  List<FavoriteItem> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Belirli bir içeriğin favori olup olmadığını kontrol et
  bool isFavorite(int id) {
    return _favoriteStatus[id] ?? false;
  }

  // Favorileri yükle
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final favoriteData = await _favoriteService.getFavorites();

      _favorites =
          favoriteData.map((data) => FavoriteItem.fromFirestore(data)).toList();

      // Favori durumlarını cache'e ekle
      _favoriteStatus.clear();
      for (var favorite in _favorites) {
        _favoriteStatus[favorite.id] = true;
      }

      log("${_favorites.length} favori yüklendi");
    } catch (e) {
      _error = e.toString();
      log("Favoriler yüklenirken hata: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Favorilere ekle
  Future<void> addToFavorites(
      int id, String title, String type, String posterPath) async {
    try {
      await _favoriteService.addToFavorites(id, title, type, posterPath);

      // Cache'i güncelle
      _favoriteStatus[id] = true;

      // Yeni favoriteyi listeye ekle
      final newFavorite = FavoriteItem(
        id: id,
        title: title,
        posterPath: posterPath,
        type: type,
        addedAt: DateTime.now(),
      );

      _favorites.insert(0, newFavorite);

      notifyListeners();
      log("Favorilere eklendi: $title");
    } catch (e) {
      log("Favorilere eklerken hata: $e");
      rethrow;
    }
  }

  // Favorilerden çıkar
  Future<void> removeFromFavorites(int id) async {
    try {
      await _favoriteService.removeFromFavorites(id);

      // Cache'i güncelle
      _favoriteStatus[id] = false;

      // Listeden çıkar
      _favorites.removeWhere((favorite) => favorite.id == id);

      notifyListeners();
      log("Favorilerden silindi: $id");
    } catch (e) {
      log("Favorilerden silerken hata: $e");
      rethrow;
    }
  }

  // Favori durumunu toggle et
  Future<void> toggleFavorite(
      int id, String title, String type, String posterPath) async {
    if (isFavorite(id)) {
      await removeFromFavorites(id);
    } else {
      await addToFavorites(id, title, type, posterPath);
    }
  }

  // Belirli bir içeriğin favori durumunu yükle
  Future<void> loadFavoriteStatus(int id) async {
    try {
      final isFav = await _favoriteService.isFavorite(id);
      _favoriteStatus[id] = isFav;
      notifyListeners();
    } catch (e) {
      log("Favori durumu yüklenirken hata: $e");
    }
  }

  // Birden fazla içeriğin favori durumunu yükle
  Future<void> loadMultipleFavoriteStatus(List<int> ids) async {
    try {
      for (int id in ids) {
        final isFav = await _favoriteService.isFavorite(id);
        _favoriteStatus[id] = isFav;
      }
      notifyListeners();
    } catch (e) {
      log("Çoklu favori durumu yüklenirken hata: $e");
    }
  }

  // Kullanıcı değiştiğinde tüm verileri temizle
  void clearAllData() {
    _favorites.clear();
    _favoriteStatus.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  // Favorileri yenile
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}
