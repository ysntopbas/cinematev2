import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  WatchListService();

  Future<void> addToWatchList(int movieId, String title, String type) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(movieId.toString())
          .set({
        'title': title,
        'type': type, // 'movie' veya 'series'
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('addToWatchList error: $e');
      rethrow;
    }
  }

  Future<void> removeFromWatchList(int movieId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      log('removeFromWatchList error: $e');
      rethrow;
    }
  }
}
