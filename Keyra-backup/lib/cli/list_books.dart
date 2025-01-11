import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../features/books/data/repositories/book_repository.dart';
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
    
    // Create BookRepository instance
    final repository = await BookRepository.create();
    
    // Get all books
    repository.getAllBooks().listen(
      (books) {
        print('\nBooks in Firestore:');
        for (final book in books) {
          print('- ${book.title} (ID: ${book.id})');
          print('  Categories: ${book.categories.join(', ')}');
          print('  Author: ${book.author}');
          print('  Number of pages: ${book.pages.length}');
          print('');
        }
      },
      onError: (error) {
        print('Error retrieving books: $error');
      },
      onDone: () {
        print('Finished retrieving books');
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}
