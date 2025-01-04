import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/config/firebase_options.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  try {
    print('Starting user stats initialization...');

    // Get all users
    final usersSnapshot = await firestore.collection('users').get();
    print('Found ${usersSnapshot.docs.length} users');

    for (final userDoc in usersSnapshot.docs) {
      print('\nProcessing user: ${userDoc.id}');

      try {
        // Get saved words count
        final savedWordsSnapshot = await userDoc.reference
            .collection('saved_words')
            .get();
        final savedWordsCount = savedWordsSnapshot.docs.length;
        print('Found $savedWordsCount saved words');

        // Get favorites count
        final favoritesSnapshot = await userDoc.reference
            .collection('favorites')
            .get();
        final favoritesCount = favoritesSnapshot.docs.length;
        print('Found $favoritesCount favorites');

        // Get current stats
        final userData = userDoc.data();
        
        // Ensure readDates is properly formatted as an array of Timestamps
        List<Timestamp> readDates = [];
        if (userData['readDates'] != null) {
          if (userData['readDates'] is List) {
            readDates = (userData['readDates'] as List)
                .map((date) {
                  if (date is Timestamp) return date;
                  if (date is Map) {
                    if (date['_seconds'] != null && date['_nanoseconds'] != null) {
                      return Timestamp(date['_seconds'], date['_nanoseconds']);
                    }
                  }
                  return null;
                })
                .where((date) => date != null)
                .cast<Timestamp>()
                .toList();
          }
        }

        // Create stats object with proper types
        final stats = {
          'booksRead': userData['booksRead'] ?? 0,
          'favoriteBooks': favoritesCount,
          'readingStreak': userData['readingStreak'] ?? 0,
          'savedWords': savedWordsCount,
          'readDates': readDates,
          'lastReadDate': userData['lastReadDate'] as Timestamp?,
          'sessionStartTime': userData['sessionStartTime'] as Timestamp?,
          'isReadingActive': userData['isReadingActive'] ?? false,
          'currentSessionMinutes': userData['currentSessionMinutes'] ?? 0,
          'lastUpdated': FieldValue.serverTimestamp(),
        };

        // Update user document with stats
        await userDoc.reference.set(stats, SetOptions(merge: true));

        print('Successfully updated stats for user ${userDoc.id}');
      } catch (e) {
        print('Error processing user ${userDoc.id}: $e');
      }
    }

    print('\nStats initialization complete!');
  } catch (e) {
    print('Error during stats initialization: $e');
  }

  // Exit the script
  print('Exiting...');
}
