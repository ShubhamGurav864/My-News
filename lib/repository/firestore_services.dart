import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a bookmarked article for a specific user.
  Future<void> addBookmark(String userId, Map<String, dynamic> article) async {
    await _firestore.collection('bookmarks').doc(userId).set({
      "articles": FieldValue.arrayUnion([article])
    }, SetOptions(merge: true));
  }

  /// Remove a bookmark for a specific user.
  Future<void> removeBookmark(
      String userId, Map<String, dynamic> article) async {
    await _firestore.collection('bookmarks').doc(userId).update({
      "articles": FieldValue.arrayRemove([article])
    });
  }

  /// Retrieve all bookmarks for a specific user.
  Future<List<Map<String, dynamic>>> getUserBookmarks(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('bookmarks').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return List<Map<String, dynamic>>.from(doc["articles"]);
    }
    return [];
  }
}
