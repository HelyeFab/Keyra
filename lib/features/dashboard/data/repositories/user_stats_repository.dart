import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
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
      // Get both the stats document and the root user document
      final statsDocRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current')
          .withConverter(
            fromFirestore: UserStats.fromFirestore,
            toFirestore: (UserStats stats, _) => stats.toFirestore(),
          );

      final userDocRef = _firestore.collection('users').doc(user.uid);

      // Get both documents
      final statsDocSnap = await statsDocRef.get();
      final userDocSnap = await userDocRef.get();
      
      // If stats document doesn't exist, initialize it
      if (!statsDocSnap.exists) {
        print('Initializing user stats document for user: ${user.uid}');
        await _initializeUserStats(user.uid);
        // Get the newly created document
        final newStatsDocSnap = await statsDocRef.get();
        final stats = newStatsDocSnap.data() ?? const UserStats();
        // Get saved words count from root user document
        final savedWords = userDocSnap.data()?['savedWords'] as int? ?? 0;
        return stats.copyWith(savedWords: savedWords);
      }

      // Get base stats from stats document
      final stats = statsDocSnap.data() ?? const UserStats();
      // Get saved words count from root user document
      final savedWords = userDocSnap.data()?['savedWords'] as int? ?? 0;
      return stats.copyWith(savedWords: savedWords);
    } catch (e) {
      print('Error getting user stats: $e');
      throw Exception('Failed to get user stats: $e');
    }
  }

  Stream<UserStats> streamUserStats() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Create streams for both documents
    final statsStream = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('current')
        .withConverter(
          fromFirestore: UserStats.fromFirestore,
          toFirestore: (UserStats stats, _) => stats.toFirestore(),
        )
        .snapshots();

    final userStream = _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots();

    // Combine both streams
    return Rx.combineLatest2(
      statsStream,
      userStream,
      (statsDoc, userDoc) async {
        if (!statsDoc.exists) {
          // Initialize the document and wait for it to complete
          await _initializeUserStats(user.uid);
          // Get the newly created document
          final newStatsDoc = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('stats')
              .doc('current')
              .withConverter(
                fromFirestore: UserStats.fromFirestore,
                toFirestore: (UserStats stats, _) => stats.toFirestore(),
              )
              .get();
          final stats = newStatsDoc.data() ?? const UserStats();
          final savedWords = userDoc.data()?['savedWords'] as int? ?? 0;
          return stats.copyWith(savedWords: savedWords);
        }
        final stats = statsDoc.data() ?? const UserStats();
        final savedWords = userDoc.data()?['savedWords'] as int? ?? 0;
        return stats.copyWith(savedWords: savedWords);
      },
    ).asyncMap((stats) => stats);
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
      
      print('Successfully initialized user stats document');
    } catch (e) {
      print('Error initializing user stats: $e');
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
      print('Error incrementing saved words: $e');
      throw Exception('Failed to increment saved words: $e');
    }
  }

  Future<void> decrementSavedWords() async {
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
        'savedWords': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error decrementing saved words: $e');
      throw Exception('Failed to decrement saved words: $e');
    }
  }

  Future<void> markBookAsRead() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    print('[UserStatsRepository] Starting markBookAsRead');
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('stats')
        .doc('current');
    final stats = await getUserStats();
    
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

    try {
      print('[UserStatsRepository] Updating Firestore with new stats');
      final batch = _firestore.batch();

      // Update stats
      batch.set(docRef, {
        'booksRead': FieldValue.increment(1),
        'readingStreak': newStreak,
        'lastReadDate': Timestamp.fromDate(today),
        'readDates': FieldValue.arrayUnion([Timestamp.fromDate(today)]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Commit the batch
      await batch.commit();

      // Get and emit the updated stats immediately
      print('[UserStatsRepository] Getting updated stats after marking book as read');
      final updatedStats = await getUserStats();
      print('[UserStatsRepository] Updated stats: $updatedStats');
      print('[UserStatsRepository] Books read: ${updatedStats.booksRead}');

      // Update the document again to trigger the stream
      await docRef.set(
        {
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('[UserStatsRepository] Error marking book as read: $e');
      throw Exception('Failed to mark book as read: $e');
    }
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
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('stats')
          .doc('current')
          .set({
        'favoriteBooks': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error incrementing favorite books: $e');
      throw Exception('Failed to increment favorite books: $e');
    }
  }

  Future<void> decrementFavoriteBooks() async {
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
        'favoriteBooks': FieldValue.increment(-1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error decrementing favorite books: $e');
      throw Exception('Failed to decrement favorite books: $e');
    }
  }
}
