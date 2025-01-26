import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/core/ui_language/service/ui_translation_service.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UiTranslationService Tests', () {
    setUp(() {
      // Clear translation cache before each test
      UiTranslationService.clearCache();
    });

    group('Translation Loading', () {
      testWidgets('loads translations asynchronously', (WidgetTester tester) async {
        bool loadingComplete = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'en',
              child: Builder(
                builder: (context) {
                  UiTranslationService.loadTranslations(context).then((_) {
                    loadingComplete = true;
                  });
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        // Wait for translations to load
        await tester.pumpAndSettle();
        expect(loadingComplete, isTrue);
      });

      testWidgets('handles missing translations gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'en',
              testTranslations: const {'existing': 'value'}, // Only one translation
              child: Builder(
                builder: (context) {
                  final result = UiTranslationService.translate(context, 'missing');
                  expect(result, equals('missing')); // Should return key as fallback
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('Cache Management', () {
      testWidgets('caches translations for better performance', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'en',
              child: Builder(
                builder: (context) {
                  // First access should cache the translation
                  final firstAccess = UiTranslationService.translate(context, 'next');
                  expect(firstAccess, equals('Next'));

                  // Second access should use cached value
                  final secondAccess = UiTranslationService.translate(context, 'next');
                  expect(secondAccess, equals('Next'));

                  // Verify cache hit (implementation specific)
                  expect(UiTranslationService.getCacheHitCount('next'), equals(1));
                  
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('handles large translation sets efficiently', (WidgetTester tester) async {
        final largeTranslations = Map.fromEntries(
          List.generate(1000, (i) => MapEntry('key_$i', 'Value $i')),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'en',
              testTranslations: largeTranslations,
              child: Builder(
                builder: (context) {
                  // Measure time to access translations
                  final stopwatch = Stopwatch()..start();
                  for (int i = 0; i < 100; i++) {
                    UiTranslationService.translate(context, 'key_$i');
                  }
                  stopwatch.stop();

                  // Performance threshold: 100ms for 100 translations
                  expect(stopwatch.elapsedMilliseconds, lessThan(100));
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    testWidgets('translates basic text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UiTranslations(
            currentLanguage: 'en',
            child: Builder(
              builder: (context) {
                final result = UiTranslationService.translate(context, 'next');
                expect(result, equals('Next'));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('handles argument replacement correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UiTranslations(
            currentLanguage: 'en',
            child: Builder(
              builder: (context) {
                final result = UiTranslationService.translate(
                  context,
                  'books_read_requirement',
                  ['5'],
                );
                expect(result, equals('5 books read required'));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('handles multiple argument replacements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UiTranslations(
            currentLanguage: 'en',
            child: Builder(
              builder: (context) {
                final result = UiTranslationService.translate(
                  context,
                  'books_read_of_limit',
                  ['3', '10'],
                );
                expect(result, equals('3 of 10 books read'));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('falls back to English when translation missing in current language', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UiTranslations(
            currentLanguage: 'pt', // Portuguese has limited translations
            child: Builder(
              builder: (context) {
                final result = UiTranslationService.translate(context, 'next');
                expect(result, equals('Next')); // Should fall back to English
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('falls back to key when translation missing in all languages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UiTranslations(
            currentLanguage: 'en',
            child: Builder(
              builder: (context) {
                final result = UiTranslationService.translate(context, 'non_existent_key');
                expect(result, equals('non_existent_key')); // Should return the key itself
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    group('handles different languages correctly', () {
      testWidgets('French translation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'fr',
              child: Builder(
                builder: (context) {
                  final result = UiTranslationService.translate(context, 'next');
                  expect(result, equals('Suivant'));
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('Spanish translation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'es',
              child: Builder(
                builder: (context) {
                  final result = UiTranslationService.translate(context, 'next');
                  expect(result, equals('Siguiente'));
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('German translation', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: UiTranslations(
              currentLanguage: 'de',
              child: Builder(
                builder: (context) {
                  final result = UiTranslationService.translate(context, 'next');
                  expect(result, equals('Weiter'));
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });
  });
}
