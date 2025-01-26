import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/user_stats.dart';

class UserStatsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserStatsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<UserStats> getUserStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      
      // Get the stats document
      final statsDocRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current');

      final statsSnap = await statsDocRef.get();
      if (!statsSnap.exists) {
        await _initializeUserStats(user.uid);
        // Get the newly created stats
        final newStatsSnap = await statsDocRef.get();
        if (!newStatsSnap.exists) {
          throw Exception('Failed to initialize user stats');
        }
        return const UserStats(
          booksRead: 0,
          favoriteBooks: 0,
          readingStreak: 0,
          savedWords: 0,
          isReadingActive: false,
          currentSessionMinutes: 0,
        );
      }

      final data = statsSnap.data() ?? {};

      // Create UserStats from the root document data
      final stats = UserStats(
        booksRead: data['booksRead'] as int? ?? 0,
        favoriteBooks: data['favoriteBooks'] as int? ?? 0,
        readingStreak: data['readingStreak'] as int? ?? 0,
        savedWords: data['savedWords'] as int? ?? 0,
        isReadingActive: data['isReadingActive'] as bool? ?? false,
        currentSessionMinutes: data['currentSessionMinutes'] as int? ?? 0,
        lastBookId: data['lastBookId'] as String?,
      );

      return stats;
    } catch (e) {
      throw Exception('Failed to get user stats: $e');
    }
  }

  Stream<UserStats> streamUserStats() async* {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }


    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('current');

    // First check if we need to initialize
    final doc = await docRef.get();
    if (!doc.exists) {
      await _initializeUserStats(user.uid);
    }

    // Now stream the document
    await for (final doc in docRef.snapshots()) {
      final data = doc.data() ?? {};

      final stats = UserStats(
        booksRead: data['booksRead'] as int? ?? 0,
        favoriteBooks: data['favoriteBooks'] as int? ?? 0,
        readingStreak: data['readingStreak'] as int? ?? 0,
        savedWords: data['savedWords'] as int? ?? 0,
        isReadingActive: data['isReadingActive'] as bool? ?? false,
        currentSessionMinutes: data['currentSessionMinutes'] as int? ?? 0,
        lastBookId: data['lastBookId'] as String?,
      );

      yield stats;
    }
  }

  Future<void> _initializeUserStats(String userId) async {
    try {
      // Create a default UserStats instance
      const defaultStats = UserStats(
        booksRead: 0,
        favoriteBooks: 0,
        readingStreak: 0,
        savedWords: 0,
        readDates: [],
        isReadingActive: false,
        currentSessionMinutes: 0,
        lastBookId: null,
      );

      // Convert to Firestore data using the model's toFirestore method
      final data = defaultStats.toFirestore();
      
      // Add server timestamp
      data['lastUpdated'] = FieldValue.serverTimestamp();

      // First ensure user document exists
      await _firestore
          .collection('users')
          .doc(userId)
          .set({
            'email': _auth.currentUser?.email,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      
      // Then create stats document
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('stats')
          .doc('current')
          .set(data);
      
    } catch (e) {
      throw Exception('Failed to initialize user stats: $e');
    }
  }

  Future<void> incrementSavedWords() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current')
          .set({
        'savedWords': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to increment saved words: $e');
    }
  }

  Future<void> decrementSavedWords() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current');

      // Get current stats to prevent negative values
      final currentStats = await getUserStats();
      if (currentStats.savedWords <= 0) {
        return;
      }

      // Update the stats only if we have saved words to decrement
      await docRef.set({
        'savedWords': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Force a refresh by updating lastUpdated
      await Future.delayed(const Duration(milliseconds: 100));
      await docRef.set({
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Verify the update
      final updatedStats = await getUserStats();
    } catch (e) {
      throw Exception('Failed to decrement saved words: $e');
    }
  }

  Future<void> markBookAsRead({required String bookId}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    
    // Use a transaction to ensure atomic updates
    await _firestore.runTransaction((transaction) async {
      final statsRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current');
      
      final subscriptionRef = _firestore
          .collection('subscriptions')
          .doc(user.uid);
      
      // Get current stats and subscription in transaction
      final statsDoc = await transaction.get(statsRef);
      final subscriptionDoc = await transaction.get(subscriptionRef);
      
      if (!statsDoc.exists || !subscriptionDoc.exists) {
        throw Exception('Stats or subscription document not found');
      }
      
      final stats = UserStats.fromFirestore(statsDoc);
      
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Check if we already read a book today
      final readToday = stats.readDates.any((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);

      // Update streak logic
      int newStreak = stats.readingStreak;
      if (!readToday) {
        if (stats.isStreakActive()) {
          // Continue streak
          newStreak += 1;
        } else {
          // Reset streak
          newStreak = 1;
        }
      }

      // Update both stats and subscription atomically
      transaction.set(statsRef, {
        'booksRead': FieldValue.increment(1),
        'readingStreak': newStreak,
        'lastReadDate': Timestamp.fromDate(today),
        'readDates': FieldValue.arrayUnion([Timestamp.fromDate(today)]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.set(subscriptionRef, {
        'booksRead': FieldValue.increment(1),
        'readBookIds': FieldValue.arrayUnion([bookId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

  }

  Future<void> startReadingSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('current')
        .set(
      {
        'sessionStartTime': Timestamp.fromDate(now),
        'isReadingActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> endReadingSession() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final stats = await getUserStats();
    if (stats.sessionStartTime == null || !stats.isReadingActive) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('current')
        .set(
      {
        'currentSessionMinutes': 0,
        'sessionStartTime': null,
        'isReadingActive': false,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> incrementFavoriteBooks() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current');

      // Get current stats first
      final currentStats = await getUserStats();

      // Update the stats
      await docRef.set({
        'favoriteBooks': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Force a refresh by updating lastUpdated
      await Future.delayed(const Duration(milliseconds: 100));
      await docRef.set({
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Verify the update
      final updatedStats = await getUserStats();
    } catch (e) {
      throw Exception('Failed to increment favorite books: $e');
    }
  }

  Future<void> decrementFavoriteBooks() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current');

      // Get current stats to prevent negative values
      final currentStats = await getUserStats();
      if (currentStats.favoriteBooks <= 0) {
        return;
      }

      // Update the stats only if we have favorites to decrement
      await docRef.set({
        'favoriteBooks': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Force a refresh by updating lastUpdated
      await Future.delayed(const Duration(milliseconds: 100));
      await docRef.set({
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Verify the update
      final updatedStats = await getUserStats();
    } catch (e) {
      throw Exception('Failed to decrement favorite books: $e');
    }
  }
}
