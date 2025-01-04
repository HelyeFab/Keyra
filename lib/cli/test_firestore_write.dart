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

    // Get fresh ID token
    final idToken = await user.getIdToken(true);
    print('Got fresh ID token');
    
    print('User auth state:');
    print('- UID: ${user.uid}');
    print('- Email: ${user.email}');
    print('- Email verified: ${user.emailVerified}');
    print('- Anonymous: ${user.isAnonymous}');

    final firestore = FirebaseFirestore.instance;

    // Test writing to user document
    print('\nTesting write to user document...');
    try {
      await firestore.collection('users').doc(user.uid).set({
        'testField': 'test value',
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Successfully wrote to user document');
    } catch (e) {
      print('Error writing to user document: $e');
    }

    // Test writing to favorites collection
    print('\nTesting write to favorites collection...');
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc('test')
          .set({
        'testField': 'test value',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Successfully wrote to favorites collection');
    } catch (e) {
      print('Error writing to favorites collection: $e');
    }

  } catch (e) {
    print('Error: $e');
  }
}
