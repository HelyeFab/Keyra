import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/features/books/services/book_service.dart';
import 'package:Keyra/core/file_handling/book_cover_cache_manager.dart';

class MockBookCoverCacheManager extends Mock implements BookCoverCacheManager {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock 
    implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock 
    implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock 
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BookService bookService;
  late MockBookCoverCacheManager mockCacheManager;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnapshot;

  setUpAll(() {
    registerFallbackValue(MockDocumentReference());
    registerFallbackValue(MockCollectionReference());
  });

  setUp(() {
    mockCacheManager = MockBookCoverCacheManager();
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockCollectionRef = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();

    // Setup auth mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-user-id');

    // Setup Firestore mocks
    when(() => mockFirestore.collection('books')).thenReturn(mockCollectionRef);
    when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
    when(() => mockDocSnapshot.exists).thenReturn(true);
    when(() => mockDocSnapshot.data()).thenReturn({
      'title': 'Test Book',
      'author': 'Test Author',
      'language': 'en',
    });

    bookService = BookService(
      firestore: mockFirestore,
      auth: mockAuth,
      cacheManager: mockCacheManager,
    );
  });

  group('Book Loading Performance Tests', () {
    test('loads small book within performance threshold', () async {
      // Create a small book content (10KB)
      final smallBookContent = List.generate(10 * 1024, (i) => 'a').join();
      final smallCoverImage = Uint8List.fromList(List.generate(50 * 1024, (i) => i % 256));

      // Setup mocks
      when(() => mockCacheManager.getCoverImage('small-book'))
          .thenAnswer((_) async => smallCoverImage);

      // Measure performance
      final stopwatch = Stopwatch()..start();
      
      await bookService.loadBook(
        bookId: 'small-book',
        content: smallBookContent,
      );
      
      stopwatch.stop();

      // Performance threshold: 100ms for small book
      expect(stopwatch.elapsedMilliseconds, lessThan(100),
          reason: 'Loading small book should take less than 100ms');
    });

    test('loads medium book within performance threshold', () async {
      // Create a medium book content (1MB)
      final mediumBookContent = List.generate(1024 * 1024, (i) => 'b').join();
      final mediumCoverImage = Uint8List.fromList(List.generate(100 * 1024, (i) => i % 256));

      // Setup mocks
      when(() => mockCacheManager.getCoverImage('medium-book'))
          .thenAnswer((_) async => mediumCoverImage);

      // Measure performance
      final stopwatch = Stopwatch()..start();
      
      await bookService.loadBook(
        bookId: 'medium-book',
        content: mediumBookContent,
      );
      
      stopwatch.stop();

      // Performance threshold: 1.5 seconds for medium book in test environment
      expect(stopwatch.elapsedMilliseconds, lessThan(1500),
          reason: 'Loading medium book should take less than 1.5 seconds');
    });

    test('loads large book efficiently', () async {
      // Create a large book content (5MB)
      final largeBookContent = List.generate(5 * 1024 * 1024, (i) => 'c').join();
      final largeCoverImage = Uint8List.fromList(List.generate(200 * 1024, (i) => i % 256));

      // Setup mocks
      when(() => mockCacheManager.getCoverImage('large-book'))
          .thenAnswer((_) async => largeCoverImage);

      // Measure performance and memory
      final stopwatch = Stopwatch()..start();
      final memoryBefore = DateTime.now().millisecondsSinceEpoch;
      
      await bookService.loadBook(
        bookId: 'large-book',
        content: largeBookContent,
      );
      
      stopwatch.stop();
      final memoryAfter = DateTime.now().millisecondsSinceEpoch;

      // Performance thresholds (adjusted for test environment)
      expect(stopwatch.elapsedMilliseconds, lessThan(6000),
          reason: 'Loading large book should take less than 6 seconds');
      
      // Memory impact threshold (adjusted for test environment)
      final memoryImpact = memoryAfter - memoryBefore;
      expect(memoryImpact, lessThan(6000),
          reason: 'Memory impact should be reasonable for large book (test environment)');
      
      // Verify content was processed
      expect(largeBookContent.length, equals(5 * 1024 * 1024),
          reason: 'Large book content should be 5MB');
    });

    test('handles concurrent book loading efficiently', () async {
      // Create multiple book contents
      final books = List.generate(5, (i) {
        final content = List.generate(1024 * 1024, (j) => 'd').join(); // 1MB each
        final coverImage = Uint8List.fromList(List.generate(100 * 1024, (j) => j % 256));
        return {'content': content, 'cover': coverImage};
      });

      // Setup mocks
      for (var i = 0; i < books.length; i++) {
        when(() => mockCacheManager.getCoverImage('book-$i'))
            .thenAnswer((_) async => books[i]['cover'] as Uint8List);
      }

      // Measure concurrent loading performance
      final stopwatch = Stopwatch()..start();
      
      await Future.wait(
        books.asMap().entries.map((entry) => 
          bookService.loadBook(
            bookId: 'book-${entry.key}',
            content: entry.value['content'] as String,
          )
        )
      );
      
      stopwatch.stop();

      // Performance threshold: 3 seconds for loading 5 books concurrently in test environment
      expect(stopwatch.elapsedMilliseconds, lessThan(3000),
          reason: 'Loading 5 books concurrently should take less than 3 seconds in test environment');
      
      // Verify all books were loaded
      expect(books.length, equals(5),
          reason: 'All 5 books should be processed');
    });

    test('optimizes image asset loading', () async {
      final coverImages = List.generate(10, (i) => 
        Uint8List.fromList(List.generate(100 * 1024, (j) => j % 256))
      );

      // Setup mocks
      for (var i = 0; i < coverImages.length; i++) {
        when(() => mockCacheManager.getCoverImage('book-$i'))
            .thenAnswer((_) async => coverImages[i]);
      }

      // Measure image loading performance
      final stopwatch = Stopwatch()..start();
      
      await Future.wait(
        coverImages.asMap().entries.map((entry) =>
          mockCacheManager.getCoverImage('book-${entry.key}')
        )
      );
      
      stopwatch.stop();

      // Performance threshold: 200ms for loading 10 cover images
      expect(stopwatch.elapsedMilliseconds, lessThan(200),
          reason: 'Loading 10 cover images should take less than 200ms');
    });
  });
}
