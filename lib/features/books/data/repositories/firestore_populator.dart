import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../sample_books.dart';
import '../../domain/models/book.dart';
import '../../domain/models/book_page.dart';
import '../../domain/models/book_language.dart';
import '../services/book_cache_service.dart';
import '../services/book_cover_cache_manager.dart';

class FirestorePopulator {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final BookCacheService _bookCacheService;
  final BookCoverCacheManager _coverCacheManager;

  FirestorePopulator({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    BookCacheService? bookCacheService,
    BookCoverCacheManager? coverCacheManager,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _bookCacheService = bookCacheService ?? BookCacheService(),
        _coverCacheManager = coverCacheManager ?? BookCoverCacheManager.instance;

  Future<List<Book>> preloadBooks() async {
    try {
      // Check if we have valid cached books
      if (_bookCacheService.hasCache) {
        final cachedBooks = _bookCacheService.getCachedBooks();
        Logger.log('Using ${cachedBooks.length} cached books');
        return cachedBooks;
      }

      Logger.log('Preloading books from Firestore...');
      final snapshot = await _firestore.collection('books').get();
      
      final books = snapshot.docs.map((doc) {
        final data = doc.data();
        return Book.fromMap(data);
      }).toList();

      // Cache the books
      await _bookCacheService.cacheBooks(books);
      
      // Pre-cache cover images
      Logger.log('Pre-caching book covers...');
      final coverUrls = books.map((book) => book.coverImage).toList();
      await _coverCacheManager.preCacheBookCovers(coverUrls);
      
      Logger.log('Successfully preloaded ${books.length} books and cached covers');
      return books;
    } catch (e) {
      Logger.error('Failed to preload books', error: e, throwError: true);
      rethrow;
    }
  }

  Future<String> uploadAsset(String assetPath, String bookId) async {
    try {
      final filename = path.basename(assetPath);
      final ref = _storage.ref().child('books/$bookId/$filename');

      // Load asset as bytes
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      // Upload to Firebase Storage
      await ref.putData(bytes);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      Logger.log('Uploaded $assetPath to Firebase Storage: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      Logger.error('Failed to upload asset', error: e, throwError: true);
      rethrow;
    }
  }

  Future<BookPage> uploadBookPageAssets(BookPage page, String bookId) async {
    String? imageUrl;
    if (page.imagePath != null && page.imagePath!.isNotEmpty) {
      imageUrl = await uploadAsset(page.imagePath!, bookId);
      // Add delay after uploading image
      await Future.delayed(const Duration(seconds: 1));
    }

    // Upload audio files
    final audioUrls = <BookLanguage, String>{};
    for (final entry in page.audioPath.entries) {
      if (entry.value.isNotEmpty) {
        final audioUrl = await uploadAsset(entry.value, bookId);
        audioUrls[entry.key] = audioUrl;
        // Add delay after each audio file upload
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return BookPage(
      text: page.text,
      imagePath: imageUrl,
      audioPath: audioUrls,
    );
  }

  Future<Book> uploadBookAssets(Book book) async {
    try {
      Logger.log('Uploading assets for book: ${book.id}');

      if (book.coverImage.isEmpty) {
        throw Exception('Book cover image path is null or empty');
      }

      // Upload cover image
      final coverUrl = await uploadAsset(book.coverImage, book.id);
      Logger.log('Cover image uploaded: $coverUrl');
      // Add delay after cover image upload
      await Future.delayed(const Duration(seconds: 1));

      // Upload page assets sequentially
      Logger.log('Uploading pages for book: ${book.id}');
      final updatedPages = <BookPage>[];
      for (final page in book.pages) {
        final updatedPage = await uploadBookPageAssets(page, book.id);
        updatedPages.add(updatedPage);
        // Add delay between pages
        await Future.delayed(const Duration(seconds: 2));
      }
      Logger.log('All page assets uploaded for book: ${book.id}');

      return book.copyWith(
        coverImage: coverUrl,
        pages: updatedPages,
      );
    } catch (e) {
      Logger.error('Failed to upload book assets', error: e, throwError: true);
      rethrow;
    }
  }

  Future<bool> areSampleBooksPopulated() async {
    try {
      // Only check if books exist, don't try to modify anything
      final snapshot = await _firestore.collection('books').get();
      Logger.log('Found ${snapshot.docs.length} books in Firestore');
      
      if (snapshot.docs.isEmpty) {
        Logger.log('No books found in Firestore');
        return false;
      }
      
      // Simply check if we have any books, don't validate or try to modify them
      return true;
    } catch (e) {
      Logger.error('Failed to check for sample books', error: e);
      return false;
    }
  }

  Future<void> populateWithSampleBooks() async {
    try {
      Logger.log('Starting to populate sample books...');
      Logger.log('Sample books to add: ${sampleBooks.length}');

      // First check if we have write permission
      Logger.log('Testing write permission...');
      await _firestore.collection('books').doc('test').set(
        {'test': true},
        SetOptions(merge: true),
      );
      Logger.log('Write permission test successful');

      // Clean up test document before proceeding
      Logger.log('Cleaning up test document...');
      await _firestore.collection('books').doc('test').delete();

      // Upload assets and update book data sequentially to avoid rate limiting
      Logger.log('Uploading assets for books...');
      final updatedBooks = <Book>[];
      for (final book in sampleBooks) {
        try {
          // Add a delay between book uploads
          if (updatedBooks.isNotEmpty) {
            await Future.delayed(const Duration(seconds: 2));
          }
          final updatedBook = await uploadBookAssets(book);
          updatedBooks.add(updatedBook);
          Logger.log('Successfully uploaded assets for book: ${book.id}');
        } catch (e) {
          Logger.error('Failed to upload assets for book', error: e, throwError: true);
          rethrow;
        }
      }
      Logger.log('Finished uploading assets for ${updatedBooks.length} books');

      // If we get here, we have write permission
      Logger.log('Creating Firestore batch...');
      final batch = _firestore.batch();

      Logger.log('Adding ${updatedBooks.length} books to batch...');
      for (final book in updatedBooks) {
        final docRef = _firestore.collection('books').doc(book.id);
        final data = book.toMap();
        Logger.log('Adding book ${book.id} to batch with data:');
        data.forEach((key, value) {
          Logger.log('  $key: $value');
        });
        batch.set(docRef, data);
      }

      Logger.log('Committing batch to Firestore...');
      try {
        await batch.commit();
        Logger.log('Successfully committed batch to Firestore');
      } catch (e) {
        Logger.error('Failed to commit batch', error: e, throwError: true);
        rethrow;
      }

      // Verify the books were added
      Logger.log('Verifying books in Firestore...');
      try {
        final snapshot = await _firestore.collection('books').get();
        Logger.log('Number of books in Firestore after population: ${snapshot.docs.length}');
        if (snapshot.docs.isEmpty) {
          Logger.error('No books found in Firestore after batch commit', throwError: true);
          // Try adding books one by one as fallback
          Logger.log('Attempting to add books individually...');
          for (final book in updatedBooks) {
            final docRef = _firestore.collection('books').doc(book.id);
            final data = book.toMap();
            Logger.log('Adding book ${book.id} individually...');
            await docRef.set(data);
            Logger.log('Successfully added book ${book.id}');
          }
        } else {
          for (final doc in snapshot.docs) {
            Logger.log('Found book in Firestore: ${doc.id}');
            Logger.log('Book data: ${doc.data()}');
          }
        }
      } catch (e) {
        Logger.error('Failed to verify books', error: e, throwError: true);
        rethrow;
      }
    } catch (e) {
      Logger.error('Failed to populate sample books', error: e);
      if (e is FirebaseException) {
        Logger.error('Firebase error details', error: e);
      }
      rethrow;
    }
  }

  Future<void> cleanupBooks() async {
    try {
      Logger.log('Cleaning up books collection...');
      
      // Delete all books from Firestore
      final snapshot = await _firestore.collection('books').get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      Logger.log('All books deleted from Firestore');

      // Delete all book assets from Storage
      final storageRef = _storage.ref().child('books');
      try {
        final items = await storageRef.listAll();
        await Future.wait([
          ...items.items.map((ref) => ref.delete()),
          ...items.prefixes.map((ref) => ref.listAll().then(
                (result) => Future.wait(result.items.map((ref) => ref.delete())),
              )),
        ]);
        Logger.log('All book assets deleted from Storage');
      } catch (e) {
        Logger.error('Failed to delete from Storage', error: e);
        // Continue even if Storage cleanup fails
      }
    } catch (e) {
      Logger.error('Failed to clean up books', error: e, throwError: true);
      rethrow;
    }
  }
}
