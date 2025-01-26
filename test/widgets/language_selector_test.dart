import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Keyra/features/common/widgets/language_selector.dart';
import 'package:Keyra/features/common/models/language.dart';

class MockLanguageCallback extends Mock {
  void call(Language language);
}

void main() {
  late List<Language> languages;
  late MockLanguageCallback mockOnLanguageSelected;

  setUp(() {
    languages = [
      const Language(code: 'en', name: 'English', flag: 'assets/flags/united-kingdom.png'),
      const Language(code: 'fr', name: 'French', flag: 'assets/flags/france.png'),
      const Language(code: 'es', name: 'Spanish', flag: 'assets/flags/spain.png'),
    ];
    mockOnLanguageSelected = MockLanguageCallback();
  });

  testWidgets('LanguageSelector displays all languages', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
          ),
        ),
      ),
    );

    // Verify all language names are displayed
    expect(find.text('English'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);
    expect(find.text('Spanish'), findsOneWidget);

    // Verify all flag images are displayed
    expect(find.image(const AssetImage('assets/flags/united-kingdom.png')), findsOneWidget);
    expect(find.image(const AssetImage('assets/flags/france.png')), findsOneWidget);
    expect(find.image(const AssetImage('assets/flags/spain.png')), findsOneWidget);
  });

  testWidgets('LanguageSelector shows selected language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[1], // French selected
            onLanguageSelected: mockOnLanguageSelected,
          ),
        ),
      ),
    );

    // Verify French is marked as selected
    final selectedTile = find.byWidgetPredicate(
      (widget) => widget is ListTile && 
                  widget.selected == true && 
                  widget.title is Text &&
                  (widget.title as Text).data == 'French',
    );
    expect(selectedTile, findsOneWidget);
  });

  testWidgets('LanguageSelector handles language selection', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
          ),
        ),
      ),
    );

    // Find and tap the French language option
    await tester.tap(find.text('French'));
    await tester.pump();

    // Verify callback was called with French language
    verify(() => mockOnLanguageSelected(languages[1])).called(1);
  });

  testWidgets('LanguageSelector handles empty language list gracefully', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: const [],
            selectedLanguage: null,
            onLanguageSelected: mockOnLanguageSelected,
          ),
        ),
      ),
    );

    // Verify empty state message is shown
    expect(find.text('No languages available'), findsOneWidget);
  });

  testWidgets('LanguageSelector displays search field when searchable is true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
            searchable: true,
          ),
        ),
      ),
    );

    // Verify search field is displayed
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('LanguageSelector filters languages based on search', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
            searchable: true,
          ),
        ),
      ),
    );

    // Enter search text
    await tester.enterText(find.byType(TextField), 'fr');
    await tester.pump();

    // Verify only French is displayed
    expect(find.text('French'), findsOneWidget);
    expect(find.text('English'), findsNothing);
    expect(find.text('Spanish'), findsNothing);
  });

  testWidgets('LanguageSelector shows no results message for empty search', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
            searchable: true,
          ),
        ),
      ),
    );

    // Enter search text that matches no languages
    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pump();

    // Verify no results message is shown
    expect(find.text('No languages found'), findsOneWidget);
  });

  testWidgets('LanguageSelector handles keyboard navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelector(
            languages: languages,
            selectedLanguage: languages[0],
            onLanguageSelected: mockOnLanguageSelected,
          ),
        ),
      ),
    );

    // Focus the first language
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    // Navigate to French using arrow key
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();

    // Select French using enter key
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    // Verify French was selected
    verify(() => mockOnLanguageSelected(languages[1])).called(1);
  });
}
