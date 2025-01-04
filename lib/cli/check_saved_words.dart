import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

void main() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('Firebase initialized successfully');
    
    // Get all users
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    
    if (usersSnapshot.docs.isEmpty) {
      print('No users found in Firestore');
      return;
    }
    
    print('\nChecking saved words for all users:');
    for (final userDoc in usersSnapshot.docs) {
      print('\nUser ID: ${userDoc.id}');
      
      // Get saved words for this user
      final savedWordsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('saved_words')
          .get();
          
      print('Number of saved words: ${savedWordsSnapshot.docs.length}');
      
      if (savedWordsSnapshot.docs.isNotEmpty) {
        print('Saved words:');
        for (final wordDoc in savedWordsSnapshot.docs) {
          print('- Word ID: ${wordDoc.id}');
          print('  Data: ${wordDoc.data()}');
        }
      }
    }
    
  } catch (e) {
    print('Error: $e');
  }
}
