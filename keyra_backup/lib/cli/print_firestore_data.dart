import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    
    // Get all books
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    
    if (snapshot.docs.isEmpty) {
      print('No books found in Firestore');
      return;
    }
    
    print('\nRaw book data in Firestore:');
    for (final doc in snapshot.docs) {
      print('\nBook ID: ${doc.id}');
      print('Data: ${doc.data()}');
    }
    
  } catch (e) {
    print('Error: $e');
  }
}
