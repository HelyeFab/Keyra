import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/semantics.dart';

void main() {
  testWidgets('Book reader screen has proper semantic labels', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Book Reader'),
            leading: Semantics(
              label: 'Back to library',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
            ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {},
              tooltip: 'Add bookmark at current position',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
              tooltip: 'Adjust font size, brightness, and more',
            ),
          ],
        ),
        body: ListView(
          children: [
            Semantics(
              label: 'Chapter 1: The Beginning',
              child: const Text('Chapter 1: The Beginning'),
            ),
            Semantics(
              label: 'Main content',
              readOnly: true,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Once upon a time in a magical forest...',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {},
                  tooltip: 'Previous page',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {},
                  tooltip: 'Next page',
                ),
              ],
            ),
          ],
        ),
      ),
    ));

    // Wait for any animations to complete
    await tester.pumpAndSettle();

    // Verify semantic properties
    expect(
      tester.getSemantics(find.byType(IconButton).first),
      matchesSemantics(
        tooltip: 'Previous page',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.text('Chapter 1: The Beginning')),
      matchesSemantics(
        label: 'Chapter 1: The Beginning\nChapter 1: The Beginning',
        textDirection: TextDirection.ltr,
      ),
    );

    expect(
      tester.getSemantics(find.text('Once upon a time in a magical forest...')),
      matchesSemantics(
        label: 'Main content\nOnce upon a time in a magical forest...',
        isReadOnly: true,
        textDirection: TextDirection.ltr,
      ),
    );

    // Navigation buttons
    expect(
      tester.getSemantics(find.byIcon(Icons.arrow_back_ios)),
      matchesSemantics(
        tooltip: 'Previous page',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.byIcon(Icons.arrow_forward_ios)),
      matchesSemantics(
        tooltip: 'Next page',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('Dictionary lookup has proper semantic descriptions', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Semantics(
              label: 'Dictionary search field',
              textField: true,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter a word to look up',
                ),
              ),
            ),
            Semantics(
              label: 'Word: Forest',
              child: const ListTile(
                title: Text('Forest'),
                subtitle: Text('A large area covered with trees'),
              ),
            ),
            Semantics(
              label: 'Translation',
              value: 'Bosque (Spanish)',
              child: const Text('Bosque'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {},
                  tooltip: 'Listen to pronunciation',
                ),
                IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {},
                  tooltip: 'Save word to favorites',
                ),
              ],
            ),
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify semantic properties
    expect(
      tester.getSemantics(find.byType(TextField)),
      matchesSemantics(
        label: 'Dictionary search field',
        isTextField: true,
      ),
    );

    expect(
      tester.getSemantics(find.byType(ListTile)),
      matchesSemantics(
        label: 'Word: Forest\nForest\nA large area covered with trees',
        hasEnabledState: true,
        isEnabled: true,
      ),
    );

    expect(
      tester.getSemantics(find.text('Bosque')),
      matchesSemantics(
        label: 'Translation\nBosque',
        value: 'Bosque (Spanish)',
        textDirection: TextDirection.ltr,
      ),
    );

    // Action buttons
    expect(
      tester.getSemantics(find.byIcon(Icons.volume_up)),
      matchesSemantics(
        tooltip: 'Listen to pronunciation',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.byIcon(Icons.star_border)),
      matchesSemantics(
        tooltip: 'Save word to favorites',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('Study session has clear semantic instructions', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Semantics(
              label: 'Study progress',
              value: '15 of 20 words reviewed',
              child: const MergeSemantics(
                child: LinearProgressIndicator(value: 0.75),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: 'Current word',
              value: 'Forest',
              child: const Text(
                'Forest',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 48), // Accessible touch target
                  ),
                  child: const Text('Show Answer'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 48), // Accessible touch target
                  ),
                  child: const Text('Next Word'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify semantic properties
    expect(
      tester.getSemantics(find.byType(LinearProgressIndicator)),
      matchesSemantics(
        value: '75%',
        textDirection: TextDirection.ltr,
      ),
    );

    expect(
      tester.getSemantics(find.text('Forest')),
      matchesSemantics(
        label: 'Current word\nForest',
        value: 'Forest',
      ),
    );

    // Action buttons
    expect(
      tester.getSemantics(find.widgetWithText(ElevatedButton, 'Show Answer')),
      matchesSemantics(
        label: 'Show Answer',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.widgetWithText(ElevatedButton, 'Next Word')),
      matchesSemantics(
        label: 'Next Word',
        isButton: true,
        hasTapAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
      ),
    );

    handle.dispose();
  });
}
