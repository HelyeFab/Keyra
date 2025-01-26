import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Keyra/core/navigation/app_navigator.dart';
import 'package:Keyra/core/navigation/routes.dart';
import 'package:Keyra/features/books/pages/book_details_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets('Navigation preserves state between routes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: Routes.home,
        ),
      ),
    );

    // Verify we're on the home page
    expect(find.text('Home'), findsOneWidget);

    // Navigate to study page
    await tester.tap(find.byIcon(Icons.school));
    await tester.pumpAndSettle();

    // Verify we're on the study page
    expect(find.text('Study'), findsOneWidget);

    // Add some study progress
    await tester.tap(find.text('Start Session'));
    await tester.pumpAndSettle();

    // Navigate back to home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Navigate back to study page
    await tester.tap(find.byIcon(Icons.school));
    await tester.pumpAndSettle();

    // Verify study progress is preserved
    expect(find.text('Session in Progress'), findsOneWidget);
  });

  testWidgets('Deep linking works correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: '${Routes.book}/123',
        ),
      ),
    );

    // Verify we're on the book details page
    expect(find.text('Book Details'), findsOneWidget);
    expect(find.byType(BookDetailsPage), findsOneWidget);

    // Verify book ID is correctly passed
    final BookDetailsPage bookPage = tester.widget(find.byType(BookDetailsPage));
    expect(bookPage.bookId, '123');
  });

  testWidgets('Navigation handles back button correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: Routes.home,
        ),
      ),
    );

    // Navigate to profile
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Navigate to settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Press back button
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify we're back on profile page
    expect(find.text('Profile'), findsOneWidget);

    // Press back button again
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify we're back on home page
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Bottom navigation preserves tab state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: Routes.home,
        ),
      ),
    );

    // Navigate to library tab
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    // Scroll the library list
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Navigate to profile tab
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Navigate back to library tab
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    // Verify scroll position is preserved
    final scrollPosition = tester.getTopLeft(find.text('Book 10')).dy;
    expect(scrollPosition, lessThan(300));
  });

  testWidgets('Modal navigation works correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: Routes.home,
        ),
      ),
    );

    // Open filter modal
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // Verify modal is shown
    expect(find.text('Filter Books'), findsOneWidget);

    // Close modal
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    // Verify modal is closed
    expect(find.text('Filter Books'), findsNothing);
  });

  testWidgets('Navigation handles errors gracefully', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: 'invalid/route',
        ),
      ),
    );

    // Verify error page is shown
    expect(find.text('Page Not Found'), findsOneWidget);
    expect(find.text('Return Home'), findsOneWidget);

    // Navigate back to home
    await tester.tap(find.text('Return Home'));
    await tester.pumpAndSettle();

    // Verify we're on home page
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Navigation handles nested navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: const AppNavigator(
          initialRoute: Routes.home,
        ),
      ),
    );

    // Navigate to library
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    // Open book details
    await tester.tap(find.text('Book 1'));
    await tester.pumpAndSettle();

    // Open chapter
    await tester.tap(find.text('Chapter 1'));
    await tester.pumpAndSettle();

    // Verify we're in the chapter view
    expect(find.text('Chapter 1 Content'), findsOneWidget);

    // Navigate back to book details
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify we're back on book details
    expect(find.text('Book Details'), findsOneWidget);
  });
}
