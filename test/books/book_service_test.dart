import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/features/books/services/book_service.dart';
import 'package:Keyra/features/books/models/reading_progress.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

void main() {
  late BookService bookService;
  late MockFirestore mockFirestore;
  late MockCollectionReference mockBooksCollection;
  late MockCollectionReference mockProgressCollection;
  late MockUser mockUser;

  setUp(() {
    mockFirestore = MockFirestore();
    mockBooksCollection = MockCollectionReference();
    mockProgressCollection = MockCollectionReference();
    mockUser = MockUser();

    when(() => mockFirestore.collection('books'))
        .thenReturn(mockBooksCollection);
    when(() => mockFirestore.collection('reading_progress'))
        .thenReturn(mockProgressCollection);
    when(() => mockUser.uid).thenReturn('test-user-id');

    bookService = BookService(
      firestore: mockFirestore,
      currentUser: mockUser,
    );
  });

  group('Book Service Tests', () {
    test('fetchBooks - returns list of books', () async {
      // Arrange
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocSnapshot = MockDocumentSnapshot();
      
      when(() => mockBooksCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({
        'title': 'Test Book',
        'author': 'Test Author',
        'language': 'en',
        'difficulty': 'intermediate',
        'coverUrl': 'https://example.com/cover.jpg',
        'contentUrl': 'https://example.com/content.pdf',
      });
      when(() => mockQueryDocSnapshot.id).thenReturn('book-1');
      when(() => mockDocSnapshot.data())
          .thenReturn({
            'title': 'Test Book',
            'author': 'Test Author',
            'language': 'en',
            'difficulty': 'intermediate',
            'coverUrl': 'https://example.com/cover.jpg',
            'contentUrl': 'https://example.com/content.pdf',
          });
      when(() => mockDocSnapshot.id).thenReturn('book-1');

      // Act
      final result = await bookService.fetchBooks();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (books) {
          expect(books.length, 1);
          expect(books.first.id, 'book-1');
          expect(books.first.title, 'Test Book');
          expect(books.first.language, 'en');
        },
      );
    });

    test('saveReadingProgress - successfully saves progress', () async {
      // Arrange
      final mockDocRef = MockDocumentReference();
      final progress = ReadingProgress(
        bookId: 'book-1',
        userId: 'test-user-id',
        currentPage: 10,
        totalPages: 100,
        lastReadTimestamp: DateTime.now(),
      );

      when(() => mockProgressCollection.doc(any()))
          .thenReturn(mockDocRef);
      when(() => mockDocRef.set(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await bookService.saveReadingProgress(progress);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDocRef.set(any())).called(1);
    });

    test('getReadingProgress - returns progress for book', () async {
      // Arrange
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQuery1 = MockQuery();
      final mockQuery2 = MockQuery();
      final now = DateTime.now();

      when(() => mockProgressCollection.where('userId', isEqualTo: 'test-user-id'))
          .thenReturn(mockQuery1);
      when(() => mockQuery1.where('bookId', isEqualTo: 'book-1'))
          .thenReturn(mockQuery2);
      when(() => mockQuery2.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({
        'bookId': 'book-1',
        'userId': 'test-user-id',
        'currentPage': 10,
        'totalPages': 100,
        'lastReadTimestamp': now.toIso8601String(),
      });
      when(() => mockQueryDocSnapshot.exists).thenReturn(true);
      when(() => mockQueryDocSnapshot.id).thenReturn('progress-1');
      when(() => mockQuerySnapshot.size).thenReturn(1);

      // Act
      final result = await bookService.getReadingProgress('book-1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (progress) {
          expect(progress.bookId, 'book-1');
          expect(progress.currentPage, 10);
          expect(progress.totalPages, 100);
        },
      );
    });

    test('getBooksByLanguage - returns filtered books', () async {
      // Arrange
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQuery = MockQuery();
      
      when(() => mockBooksCollection.where('language', isEqualTo: 'fr'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({
        'title': 'French Book',
        'author': 'French Author',
        'language': 'fr',
        'difficulty': 'beginner',
        'coverUrl': 'https://example.com/cover.jpg',
        'contentUrl': 'https://example.com/content.pdf',
      });
      when(() => mockQueryDocSnapshot.id).thenReturn('book-2');
      when(() => mockQueryDocSnapshot.exists).thenReturn(true);
      when(() => mockQuerySnapshot.size).thenReturn(1);

      // Act
      final result = await bookService.getBooksByLanguage('fr');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (books) {
          expect(books.length, 1);
          expect(books.first.language, 'fr');
          expect(books.first.title, 'French Book');
        },
      );
    });

    test('getBooksByDifficulty - returns filtered books', () async {
      // Arrange
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQuery = MockQuery();
      
      when(() => mockBooksCollection.where('difficulty', isEqualTo: 'advanced'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      final mockQueryDocSnapshot = MockQueryDocumentSnapshot();
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({
        'title': 'Advanced Book',
        'author': 'Test Author',
        'language': 'en',
        'difficulty': 'advanced',
        'coverUrl': 'https://example.com/cover.jpg',
        'contentUrl': 'https://example.com/content.pdf',
      });
      when(() => mockQueryDocSnapshot.id).thenReturn('book-3');
      when(() => mockQueryDocSnapshot.exists).thenReturn(true);
      when(() => mockQuerySnapshot.size).thenReturn(1);

      // Act
      final result = await bookService.getBooksByDifficulty('advanced');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (books) {
          expect(books.length, 1);
          expect(books.first.difficulty, 'advanced');
          expect(books.first.title, 'Advanced Book');
        },
      );
    });
  });
}
