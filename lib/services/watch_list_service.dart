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
}
