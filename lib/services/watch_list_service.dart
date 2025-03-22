import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  WatchListService();

  Future<void> addToWatchList(int id, String title, String type) async {
    try {
      if (type == 'movie') {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('watchListMovies')
            .doc(id.toString())
            .set({
          'title': title,
          'type': type, // 'movie' veya 'series'
          'isAdded': true,
          'addedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('watchListSeries')
            .doc(id.toString())
            .set({
          'title': title,
          'type': type, // 'movie' veya 'series'
          'isAdded': true,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      log('addToWatchList error: $e');
      rethrow;
    }
  }

  Future<void> removeFromWatchList(int id, String type) async {
    try {
      if (type == 'movie') {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('watchListMovies')
            .doc(id.toString())
            .delete();
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('watchListSeries')
            .doc(id.toString())
            .delete();
      }
    } catch (e) {
      log('removeFromWatchList error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFetchWatchList(String type) async {
    try {
      // Kullanıcının izleme listesi için uygun koleksiyonu seçiyoruz
      var collection = type == 'movie'
          ? _firestore
              .collection('users')
              .doc(userId)
              .collection('watchListMovies')
          : _firestore
              .collection('users')
              .doc(userId)
              .collection('watchListSeries');

      // Verileri çekiyoruz
      var snapshot = await collection.get();

      // Verileri bir listeye dönüştürüyoruz
      List<Map<String, dynamic>> watchList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'type': doc['type'],
          'isAdded': doc['isAdded'],
          'addedAt': doc['addedAt'],
        };
      }).toList();

      return watchList;
    } catch (e) {
      log('getFetchWatchList error: $e');
      rethrow;
    }
  }
}
