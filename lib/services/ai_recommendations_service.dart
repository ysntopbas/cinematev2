import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiRecommendationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  // Kullanıcının AI önerilerini Firebase'den al
  Future<Map<String, dynamic>?> getUserRecommendations() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiRecommendations')
          .doc('current')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data();
      }
      return null;
    } catch (e) {
      log('Kullanıcı önerileri alınırken hata: $e');
      return null;
    }
  }

  // Kullanıcının AI önerilerini Firebase'e kaydet
  Future<void> saveUserRecommendations(
      Map<String, dynamic> recommendations) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiRecommendations')
          .doc('current')
          .set({
        'recommendations': recommendations,
        'createdAt': FieldValue.serverTimestamp(),
        'watchedItems': <String, bool>{}, // Boş izleme durumu
      });

      log('AI önerileri Firebase\'e kaydedildi');
    } catch (e) {
      log('AI önerileri kaydedilirken hata: $e');
      rethrow;
    }
  }

  // Kullanıcının izleme durumlarını güncelle
  Future<void> updateWatchedStatus(Map<String, bool> watchedItems) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiRecommendations')
          .doc('current')
          .update({
        'watchedItems': watchedItems,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('İzleme durumu güncellenirken hata: $e');
      rethrow;
    }
  }

  // Kullanıcının önceki önerilerini sil
  Future<void> clearUserRecommendations() async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiRecommendations')
          .doc('current')
          .delete();

      log('Önceki AI önerileri temizlendi');
    } catch (e) {
      log('AI önerileri temizlenirken hata: $e');
      rethrow;
    }
  }

  // Kullanıcının AI önerilerinin olup olmadığını kontrol et
  Future<bool> hasUserRecommendations() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('aiRecommendations')
          .doc('current')
          .get();

      return doc.exists && doc.data() != null;
    } catch (e) {
      log('Öneri kontrolü yapılırken hata: $e');
      return false;
    }
  }
}
