import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('Firebase initialized successfully');
    
    // Get current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in. Please log in first.');
      return;
    }

    final firestore = FirebaseFirestore.instance;
    
    // Create or update user document
    await firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'lastUpdated': FieldValue.serverTimestamp(),
      'role': 'user',  // Default role
    }, SetOptions(merge: true));
    
    // Get first book from books collection to use as test favorite
    final booksSnapshot = await firestore.collection('books').limit(1).get();
    if (booksSnapshot.docs.isNotEmpty) {
      final firstBook = booksSnapshot.docs.first;
      
      // Add test favorite
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(firstBook.id)
          .set({
        'bookId': firstBook.id,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      print('Added test favorite with bookId: ${firstBook.id}');
    } else {
      print('No books found in the books collection');
    }
    
    print('Firestore structure initialized successfully for user: ${user.email}');
    
  } catch (e) {
    print('Error: $e');
  }
}
