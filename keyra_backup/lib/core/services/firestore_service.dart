import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getSavedWordsWithDetails() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include the document ID
        return data;
      }).toList();
    });
  }

  Future<void> deleteSavedWord(String wordId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    
    // Start a batch write
    final batch = _firestore.batch();
    
    // Delete the word document
    final wordRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .doc(wordId);
    batch.delete(wordRef);
    
    // Get the new count of saved words
    final savedWordsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .get();
    
    // The count will be one less since we're about to delete a word
    final newCount = savedWordsSnapshot.docs.length - 1;
    
    // Update the saved words count in user stats
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'savedWords': newCount,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    
    // Commit the batch
    await batch.commit();
  }
}
