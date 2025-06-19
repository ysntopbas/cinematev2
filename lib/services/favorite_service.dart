import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  // Favori ekle
  Future<void> addToFavorites(
      int id, String title, String type, String posterPath) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(id.toString())
          .set({
        'id': id,
        'title': title,
        'type': type, // 'movie' veya 'tv'
        'posterPath': posterPath,
        'addedAt': FieldValue.serverTimestamp(),
      });

      log("Favorilere eklendi: $title");
    } catch (e) {
      log("Favorilere eklerken hata: $e");
      rethrow;
    }
  }

  // Favorilerden çıkar
  Future<void> removeFromFavorites(int id) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(id.toString())
          .delete();

      log("Favorilerden silindi: $id");
    } catch (e) {
      log("Favorilerden silerken hata: $e");
      rethrow;
    }
  }

  // Favori listesini getir
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Favoriler getirilirken hata: $e");
      return [];
    }
  }

  // Belirli bir içeriğin favori olup olmadığını kontrol et
  Future<bool> isFavorite(int id) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(id.toString())
          .get();

      return doc.exists;
    } catch (e) {
      log("Favori kontrolü yapılırken hata: $e");
      return false;
    }
  }

  // Belirli bir tip için favori listesini getir (movies veya tv)
  Future<List<Map<String, dynamic>>> getFavoritesByType(String type) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .where('type', isEqualTo: type)
          .orderBy('addedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("Tip bazlı favoriler getirilirken hata: $e");
      return [];
    }
  }
}
