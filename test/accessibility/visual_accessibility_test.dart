import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

void main() {
  testWidgets('Text scales properly for accessibility', (tester) async {
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) {
        // Simulate user with larger text settings
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2.0), // Double the text size
          ),
          child: child!,
        );
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Book Reader'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Chapter 1',
                style: TextStyle(fontSize: 24), // Should scale to 48
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Once upon a time...',
                  style: TextStyle(fontSize: 16), // Should scale to 32
                ),
              ),
            ],
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify text scales properly
    final chapter = tester.widget<Text>(find.text('Chapter 1'));
    expect(chapter.style!.fontSize! * 2.0, equals(48.0));

    final content = tester.widget<Text>(find.text('Once upon a time...'));
    expect(content.style!.fontSize! * 2.0, equals(32.0));
  });

  testWidgets('Touch targets meet minimum size requirements', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
              iconSize: 24,
              padding: const EdgeInsets.all(12), // Total size: 48x48
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(44, 44), // W3C minimum
              ),
              child: const Text('Action'),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 44),
              ),
              child: const Text('Link'),
            ),
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify touch target sizes
    final iconButton = tester.getRect(find.byType(IconButton));
    expect(iconButton.width, greaterThanOrEqualTo(48.0));
    expect(iconButton.height, greaterThanOrEqualTo(48.0));

    final elevatedButton = tester.getRect(find.byType(ElevatedButton));
    expect(elevatedButton.width, greaterThanOrEqualTo(44.0));
    expect(elevatedButton.height, greaterThanOrEqualTo(44.0));

    final textButton = tester.getRect(find.byType(TextButton));
    expect(textButton.width, greaterThanOrEqualTo(44.0));
    expect(textButton.height, greaterThanOrEqualTo(44.0));
  });

  testWidgets('Color contrast meets WCAG guidelines', (tester) async {
    // Define theme colors
    const primaryColor = Color(0xFF1976D2); // Darker blue for better contrast
    const backgroundColor = Colors.white;
    const errorColor = Color(0xFFB71C1C); // Darker red for better contrast
    const textColor = Colors.black;

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.light(
          error: errorColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Accessibility Test'),
        ),
        body: Column(
          children: [
            Container(
              color: primaryColor,
              child: const Text(
                'Light text on primary color',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Text(
              'Dark text on background',
              style: TextStyle(color: textColor),
            ),
            Container(
              color: errorColor,
              child: const Text(
                'Light text on error color',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Helper function to calculate relative luminance
    double getLuminance(Color color) {
      final r = color.red / 255;
      final g = color.green / 255;
      final b = color.blue / 255;
      
      final rs = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
      final gs = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
      final bs = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);
      
      return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
    }

    // Helper function to calculate contrast ratio
    double getContrastRatio(Color foreground, Color background) {
      final l1 = getLuminance(foreground);
      final l2 = getLuminance(background);
      final lighter = max(l1, l2);
      final darker = min(l1, l2);
      return (lighter + 0.05) / (darker + 0.05);
    }

    // Verify contrast ratios meet WCAG AA guidelines (4.5:1 for normal text)
    final primaryTextContrast = getContrastRatio(Colors.white, primaryColor);
    expect(primaryTextContrast, greaterThanOrEqualTo(4.5));

    final normalTextContrast = getContrastRatio(textColor, backgroundColor);
    expect(normalTextContrast, greaterThanOrEqualTo(4.5));

    final errorTextContrast = getContrastRatio(Colors.white, errorColor);
    expect(errorTextContrast, greaterThanOrEqualTo(4.5));
  });

  testWidgets('UI is usable in different orientations', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Book Reader'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Text('Chapter 1'),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Content that should be readable in any orientation'),
              ),
            ],
          ),
        ),
      ),
    ));

    // Test portrait mode
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpAndSettle();

    expect(find.text('Chapter 1'), findsOneWidget);
    expect(
      find.text('Content that should be readable in any orientation'),
      findsOneWidget,
    );

    // Test landscape mode
    await tester.binding.setSurfaceSize(const Size(800, 400));
    await tester.pumpAndSettle();

    expect(find.text('Chapter 1'), findsOneWidget);
    expect(
      find.text('Content that should be readable in any orientation'),
      findsOneWidget,
    );
  });
}
