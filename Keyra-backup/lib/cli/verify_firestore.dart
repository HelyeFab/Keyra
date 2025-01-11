import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }
    print('Current user: ${user.uid} (${user.email})');

    final firestore = FirebaseFirestore.instance;

    // Check books collection
    print('\nChecking books collection...');
    final booksSnapshot = await firestore.collection('books').get();
    print('Total books: ${booksSnapshot.docs.length}');
    for (var doc in booksSnapshot.docs) {
      print('Book: ${doc.id}');
      print('Data: ${doc.data()}');
    }

    // Check user document
    print('\nChecking user document...');
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      print('User document exists');
      print('Data: ${userDoc.data()}');
    } else {
      print('User document does not exist');
    }

    // Check favorites collection
    print('\nChecking favorites collection...');
    final favoritesSnapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    print('Total favorites: ${favoritesSnapshot.docs.length}');
    for (var doc in favoritesSnapshot.docs) {
      print('Favorite: ${doc.id}');
      print('Data: ${doc.data()}');
    }

  } catch (e) {
    print('Error: $e');
  }
}
