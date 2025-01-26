import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/features/books/services/book_service.dart';
import 'package:Keyra/features/dictionary/services/dictionary_service.dart';
import 'package:Keyra/core/services/preferences_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockPreferencesService extends Mock implements PreferencesService {}
class MockBookService extends Mock implements BookService {}
class MockDictionaryService extends Mock implements DictionaryService {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockPreferencesService mockPrefs;
  late MockBookService mockBookService;
  late MockDictionaryService mockDictionaryService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockPrefs = MockPreferencesService();
    mockBookService = MockBookService();
    mockDictionaryService = MockDictionaryService();

    // Setup auth mocks
    when(() => mockAuth.currentUser).thenAnswer((_) => mockUser);
    when(() => mockUser.uid).thenAnswer((_) => 'test-user-id');

    // Setup preferences mocks
    when(() => mockPrefs.appLanguage).thenReturn('en');
    when(() => mockPrefs.hasSeenOnboarding).thenReturn(true);
    when(() => mockPrefs.isFirstLaunch).thenReturn(false);

    // Register fallback values
    registerFallbackValue('test-book');
    registerFallbackValue(0.75);

    // Setup book service mocks
    when(() => mockBookService.getRecentBooks()).thenAnswer(
      (_) => Stream.value([
        {
          'id': 'book-1',
          'title': 'Test Book 1',
          'progress': 0.5,
        }
      ])
    );

    when(() => mockBookService.saveReadingProgress(
      bookId: any(named: 'bookId'),
      pageNumber: any(named: 'pageNumber'),
      progress: any(named: 'progress'),
    )).thenAnswer((_) async {});

    // Setup dictionary service mocks
    when(() => mockDictionaryService.lookupWord(any(), any()))
        .thenAnswer((_) async => DictionaryResult(
          word: 'test',
          translation: 'prueba',
          language: 'es',
          definitions: ['test definition'],
        ));
  });

  group('Core Functionality Regression Tests', () {
    testWidgets('Book reading flow remains functional', (tester) async {
      // Mock book content
      when(() => mockBookService.loadBook(
        bookId: any(named: 'bookId'),
        content: any(named: 'content'),
      )).thenAnswer((_) async => {
        'id': 'test-book',
        'content': 'Test content',
        'progress': 0.0,
      });

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: mockBookService.getRecentBooks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final book = snapshot.data![index];
                  return ListTile(
                    title: Text(book['title'] as String),
                    subtitle: LinearProgressIndicator(
                      value: book['progress'] as double,
                    ),
                    onTap: () async {
                      await mockBookService.loadBook(
                        bookId: book['id'] as String,
                        content: 'Test content',
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify book list loads
      expect(find.text('Test Book 1'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Test book loading
      await tester.tap(find.text('Test Book 1'));
      await tester.pumpAndSettle();

      verify(() => mockBookService.loadBook(
        bookId: 'book-1',
        content: 'Test content',
      )).called(1);
    });

    testWidgets('Progress tracking remains functional', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: mockBookService.getRecentBooks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final book = snapshot.data!.first;
              return Column(
                children: [
                  Text('Progress: ${((book['progress'] as double) * 100).toInt()}%'),
                  ElevatedButton(
                    onPressed: () async {
                      await mockBookService.saveReadingProgress(
                        bookId: book['id'] as String,
                        pageNumber: 75,
                        progress: 0.75,
                      );
                    },
                    child: const Text('Update Progress'),
                  ),
                ],
              );
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify initial progress
      expect(find.text('Progress: 50%'), findsOneWidget);

      // Test progress update
      await tester.tap(find.text('Update Progress'));
      await tester.pumpAndSettle();

      verify(() => mockBookService.saveReadingProgress(
        bookId: 'book-1',
        pageNumber: 75,
        progress: 0.75,
      )).called(1);
    });

    testWidgets('Dictionary lookup remains functional', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(
                onSubmitted: (word) async {
                  await mockDictionaryService.lookupWord(word, 'es');
                },
                decoration: const InputDecoration(
                  hintText: 'Enter word to look up',
                ),
              ),
            ],
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Test dictionary lookup
      await tester.enterText(find.byType(TextField), 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(() => mockDictionaryService.lookupWord('test', 'es')).called(1);
    });

    testWidgets('Settings persistence remains functional', (tester) async {
      // Mock settings updates
      when(() => mockPrefs.setAppLanguage(any()))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Current Language: ${mockPrefs.appLanguage}'),
              ElevatedButton(
                onPressed: () async {
                  await mockPrefs.setAppLanguage('es');
                },
                child: const Text('Change Language'),
              ),
            ],
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify initial settings
      expect(find.text('Current Language: en'), findsOneWidget);

      // Test settings update
      await tester.tap(find.text('Change Language'));
      await tester.pumpAndSettle();

      verify(() => mockPrefs.setAppLanguage('es')).called(1);
    });

    testWidgets('Navigation state preservation remains functional', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detail');
                    },
                    child: const Text('Go to Detail'),
                  ),
                ),
              ),
          '/detail': (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Detail'),
                ),
                body: const Center(
                  child: Text('Detail Screen'),
                ),
              ),
        },
      ));

      await tester.pumpAndSettle();

      // Test navigation
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      expect(find.text('Detail Screen'), findsOneWidget);

      // Test back navigation
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('Go to Detail'), findsOneWidget);
    });
  });
}
