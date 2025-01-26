import 'package:Keyra/core/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DictionaryResult {
  final String word;
  final String translation;
  final String language;
  final List<String> definitions;
  final List<String> examples;
  final List<String> synonyms;

  DictionaryResult({
    required this.word,
    required this.translation,
    required this.language,
    required this.definitions,
    this.examples = const [],
    this.synonyms = const [],
  });

  factory DictionaryResult.fromMap(Map<String, dynamic> map) {
    return DictionaryResult(
      word: map['word'] as String,
      translation: map['translation'] as String,
      language: map['language'] as String,
      definitions: List<String>.from(map['definitions'] as List),
      examples: map['examples'] != null 
          ? List<String>.from(map['examples'] as List) 
          : [],
      synonyms: map['synonyms'] != null 
          ? List<String>.from(map['synonyms'] as List) 
          : [],
    );
  }
}

class DictionaryService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Map<String, DictionaryResult> _cache = {};

  DictionaryService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<DictionaryResult> lookupWord(String word, String targetLanguage) async {
    // Check cache first
    final cacheKey = '${word}_$targetLanguage';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Query Firestore
    final docRef = _firestore.collection('dictionary').doc(word);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Word not found');
    }

    final data = doc.data()!;
    final result = DictionaryResult.fromMap(data);

    // Cache the result
    _cache[cacheKey] = result;

    // Update user's lookup history in background
    _updateLookupHistory(word, targetLanguage).catchError((error) {
      // Log error but don't fail the lookup
      Logger.error('Failed to update lookup history', error: error);
    });

    return result;
  }

  Future<void> _updateLookupHistory(String word, String language) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('lookup_history')
        .doc(word)
        .set({
      'word': word,
      'language': language,
      'lastLookup': FieldValue.serverTimestamp(),
      'lookupCount': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<List<DictionaryResult>> batchLookup(
    List<String> words,
    String targetLanguage,
  ) async {
    return Future.wait(
      words.map((word) => lookupWord(word, targetLanguage))
    );
  }

  void clearCache() {
    _cache.clear();
  }

  bool hasCached(String word, String language) {
    return _cache.containsKey('${word}_$language');
  }
}
