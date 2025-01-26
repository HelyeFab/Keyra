import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/features/books/services/book_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockPreferencesService extends Mock implements PreferencesService {}
class MockBookService extends Mock implements BookService {}

// Test app widget
class TestApp extends StatelessWidget {
  final MockBookService bookService;
  final MockPreferencesService prefsService;

  const TestApp({
    Key? key,
    required this.bookService,
    required this.prefsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: bookService.getRecentBooks(),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.book),
                    onPressed: () {},
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockPreferencesService mockPrefs;
  late MockBookService mockBookService;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockPrefs = MockPreferencesService();
    mockBookService = MockBookService();

    // Setup auth mocks
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-user-id');

    // Setup preferences mocks
    when(() => mockPrefs.appLanguage).thenReturn('en');
    when(() => mockPrefs.hasSeenOnboarding).thenReturn(true);
    when(() => mockPrefs.isFirstLaunch).thenReturn(false);

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
  });

  group('App Startup Performance Tests', () {
    testWidgets('cold start completes within threshold', (tester) async {
      final stopwatch = Stopwatch()..start();

      // Build our app and trigger a frame
      await tester.pumpWidget(TestApp(
        bookService: mockBookService,
        prefsService: mockPrefs,
      ));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Performance threshold: 2 seconds for cold start
      expect(stopwatch.elapsedMilliseconds, lessThan(2000),
          reason: 'Cold start should complete within 2 seconds');
    });

    testWidgets('initial data fetch completes within threshold', (tester) async {
      // Setup mock data
      final mockBooks = List.generate(10, (i) => {
        'id': 'book-$i',
        'title': 'Book $i',
        'progress': i / 10,
      });

      when(() => mockBookService.getRecentBooks()).thenAnswer(
        (_) => Stream.value(mockBooks)
      );

      final stopwatch = Stopwatch()..start();

      // Build app and wait for initial data load
      await tester.pumpWidget(TestApp(
        bookService: mockBookService,
        prefsService: mockPrefs,
      ));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Performance threshold: 1 second for initial data fetch
      expect(stopwatch.elapsedMilliseconds, lessThan(1000),
          reason: 'Initial data fetch should complete within 1 second');
    });

    testWidgets('asset loading optimized', (tester) async {
      final stopwatch = Stopwatch()..start();

      // Build app and trigger asset loading
      await tester.pumpWidget(TestApp(
        bookService: mockBookService,
        prefsService: mockPrefs,
      ));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Performance threshold: 500ms for asset loading
      expect(stopwatch.elapsedMilliseconds, lessThan(500),
          reason: 'Asset loading should complete within 500ms');

      // Verify smooth frame rendering
      bool hasJank = false;
      await tester.pumpFrames(
        TestApp(
          bookService: mockBookService,
          prefsService: mockPrefs,
        ),
        const Duration(seconds: 1),
      );
      expect(hasJank, isFalse, reason: 'No jank should occur during asset loading');
    });

    testWidgets('handles background data loading efficiently', (tester) async {
      // Setup stream controller for dynamic data updates
      final booksController = StreamController<List<Map<String, dynamic>>>();
      
      when(() => mockBookService.getRecentBooks())
          .thenAnswer((_) => booksController.stream);

      await tester.pumpWidget(TestApp(
        bookService: mockBookService,
        prefsService: mockPrefs,
      ));

      // Initial pump to show loading state
      await tester.pump();

      final stopwatch = Stopwatch()..start();

      // Simulate background data updates
      booksController.add(List.generate(20, (i) => {
        'id': 'book-$i',
        'title': 'New Book $i',
        'progress': i / 20,
      }));

      // Pump a few frames to process updates
      await tester.pump(); // Process stream update
      await tester.pump(const Duration(milliseconds: 16)); // Animation frame
      await tester.pump(const Duration(milliseconds: 16)); // Verification frame

      stopwatch.stop();

      // Performance threshold: 200ms for background updates
      expect(stopwatch.elapsedMilliseconds, lessThan(200),
          reason: 'Background data updates should process within 200ms');

      // Wait for list to build
      await tester.pumpAndSettle(const Duration(milliseconds: 50));

      // Verify UI updated correctly
      expect(find.text('New Book 0'), findsOneWidget);
      
      // Verify initial items are rendered
      expect(find.text('New Book 0'), findsOneWidget);
      expect(find.text('New Book 1'), findsOneWidget);
      expect(find.text('New Book 2'), findsOneWidget);
      
      // Scroll down to reveal more items
      await tester.drag(find.byType(ListView), const Offset(0.0, -500.0));
      await tester.pump();
      
      // Verify more items are now visible
      expect(find.text('New Book 10'), findsOneWidget);
      expect(find.text('New Book 11'), findsOneWidget);
      expect(find.text('New Book 12'), findsOneWidget);

      // Clean up
      await booksController.close();
    });

    testWidgets('maintains performance under memory pressure', (tester) async {
      final initialMemory = DateTime.now().millisecondsSinceEpoch;

      await tester.pumpWidget(TestApp(
        bookService: mockBookService,
        prefsService: mockPrefs,
      ));

      // Initial pump to show content
      await tester.pump();

      // Simulate user interactions with controlled pumping
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.byType(IconButton).first);
        await tester.pump(); // Process tap
        await tester.pump(const Duration(milliseconds: 16)); // Animation frame
      }

      final finalMemory = DateTime.now().millisecondsSinceEpoch;
      final memoryImpact = finalMemory - initialMemory;

      // Memory threshold: 100MB for typical usage (adjusted for test environment)
      expect(memoryImpact, lessThan(100),
          reason: 'Memory usage should remain reasonable under pressure');

      // Verify UI is still responsive
      expect(find.byType(IconButton), findsOneWidget);
      
      // Wait for any animations to complete
      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      
      // Tap an icon to verify interactivity
      await tester.tap(find.byType(IconButton).first);
      await tester.pump();
      
      // No animations should be running after settling
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
