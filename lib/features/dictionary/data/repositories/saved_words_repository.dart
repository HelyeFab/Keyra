import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/saved_word.dart';
import '../../domain/services/spaced_repetition_service.dart';
import '../../../dashboard/data/repositories/user_stats_repository.dart';

class SavedWordsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;

  SavedWordsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository();

  Future<bool> isWordSaved(String word) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_words')
          .where('word', isEqualTo: word.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if word is saved: $e');
      throw Exception('Failed to check if word is saved');
    }
  }

  Future<void> saveWord(SavedWord word) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check if word is already saved
      if (await isWordSaved(word.word)) {
        throw Exception('Word is already saved');
      }

      // Start a batch write
      final batch = _firestore.batch();
      
      final userRef = _firestore.collection('users').doc(user.uid);
      final wordsRef = userRef.collection('saved_words');

      // Add the word
      batch.set(wordsRef.doc(word.id), word.toFirestore());

      // Commit the batch
      await batch.commit();
      
      // Update saved words count in both places
      await _updateSavedWordsCount();
      await _userStatsRepository.incrementSavedWords();
      
      print('Successfully saved word and updated counts');
    } catch (e) {
      print('Error saving word: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> removeWord(String wordId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Start a batch write
      final batch = _firestore.batch();
      
      final userRef = _firestore.collection('users').doc(user.uid);
      final wordRef = userRef.collection('saved_words').doc(wordId);

      // Delete the word
      batch.delete(wordRef);

      // Commit the batch
      await batch.commit();
      
      // Update saved words count in both places
      await _updateSavedWordsCount();
      await _userStatsRepository.decrementSavedWords();
      
      print('Successfully removed word and updated counts');
    } catch (e) {
      print('Error removing word: $e');
      throw Exception('Failed to remove word');
    }
  }

  Future<void> updateWord(SavedWord word) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      print('Updating word in Firebase: ${word.word}');
      print('Word data: ${word.toFirestore()}');
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_words')
          .doc(word.id)
          .update(word.toFirestore());
      
      print('Successfully updated word: ${word.word}');
    } catch (e) {
      print('Error updating word: $e');
      print('Error details: ${e.toString()}');
      throw Exception('Failed to update word: ${e.toString()}');
    }
  }

  Future<void> _updateSavedWordsCount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get the actual count of saved words
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_words')
          .count()
          .get();

      final actualCount = querySnapshot.count;

      // Update the user stats with the actual count
      await _firestore.collection('users').doc(user.uid).set({
        'savedWords': actualCount,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Successfully updated saved words count to: $actualCount');
    } catch (e) {
      print('Error updating saved words count: $e');
      throw Exception('Failed to update saved words count');
    }
  }

  Stream<List<SavedWord>> getSavedWords({String? language}) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_words');

    // First filter by language if specified, then order by savedAt
    if (language != null) {
      query = query.where('language', isEqualTo: language);
    }
    
    // Apply ordering after any filters
    query = query.orderBy('savedAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SavedWord.fromFirestore(doc);
      }).toList();
    });
  }

  Future<List<SavedWord>> getSavedWordsList({String? language}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_words');

    // First filter by language if specified, then order by savedAt
    if (language != null) {
      query = query.where('language', isEqualTo: language);
    }
    
    // Apply ordering after any filters
    query = query.orderBy('savedAt', descending: true);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => SavedWord.fromFirestore(doc)).toList();
  }

  Future<List<SavedWord>> getDueWords({String? language}) async {
    final words = await getSavedWordsList(language: language);
    final spacedRepetitionService = SpacedRepetitionService();
    return spacedRepetitionService.getDueWords(words);
  }

  Stream<Map<String, int>> getWordProgressCounts({String? language}) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('saved_words');
    
    if (language != null) {
      query = query.where('language', isEqualTo: language.toLowerCase());
    }

    return query.snapshots().map((snapshot) {
      final counts = {
        'new': 0,
        'learning': 0,
        'learned': 0,
      };

      for (var doc in snapshot.docs) {
        final progress = doc.data()['progress'] as int? ?? 0;
        if (progress == 0) {
          counts['new'] = (counts['new'] ?? 0) + 1;
        } else if (progress == 1) {
          counts['learning'] = (counts['learning'] ?? 0) + 1;
        } else {
          counts['learned'] = (counts['learned'] ?? 0) + 1;
        }
      }

      print('Word counts: $counts');
      return counts;
    });
  }
}
