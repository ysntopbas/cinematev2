import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final int id;
  final String title;
  final String posterPath;
  final String type; // 'movie' veya 'tv'
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.type,
    required this.addedAt,
  });

  // Firebase'den gelen data'yı FavoriteItem'a çevir
  factory FavoriteItem.fromFirestore(Map<String, dynamic> data) {
    return FavoriteItem(
      id: data['id'],
      title: data['title'],
      posterPath: data['posterPath'],
      type: data['type'],
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // FavoriteItem'ı Firebase'e göndermek için Map'e çevir
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'type': type,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
