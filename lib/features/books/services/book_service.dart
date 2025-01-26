import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/file_handling/book_cover_cache_manager.dart';

class BookService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final BookCoverCacheManager _cacheManager;

  BookService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required BookCoverCacheManager cacheManager,
  })  : _firestore = firestore,
        _auth = auth,
        _cacheManager = cacheManager;

  Future<Map<String, dynamic>> loadBook({
    required String bookId,
    required String content,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Load cover image from cache
    final coverImage = await _cacheManager.getCoverImage(bookId);

    // Process book content (in a real implementation, this would parse and format the content)
    final processedContent = await _processBookContent(content);

    // Get book metadata from Firestore
    final bookDoc = await _firestore
        .collection('books')
        .doc(bookId)
        .get();

    if (!bookDoc.exists) {
      throw Exception('Book not found');
    }

    return {
      'id': bookId,
      'content': processedContent,
      'coverImage': coverImage,
      'metadata': bookDoc.data(),
    };
  }

  Future<String> _processBookContent(String content) async {
    // Simulate content processing with some delay based on content size
    await Future.delayed(Duration(milliseconds: content.length ~/ 1024));
    return content;
  }

  Future<void> saveReadingProgress({
    required String bookId,
    required int pageNumber,
    required double progress,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('reading_progress')
        .doc(bookId)
        .set({
      'pageNumber': pageNumber,
      'progress': progress,
      'lastRead': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> getRecentBooks() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('reading_progress')
        .orderBy('lastRead', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList());
  }
}
