import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io' show Platform;

void main() {
  testWidgets('Platform-specific navigation follows OS conventions', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: Platform.isIOS
                ? CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.pop(context),
                  )
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
            title: const Text('Book Details'),
          ),
          body: const Center(
            child: Text('Platform-specific navigation test'),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    if (Platform.isIOS) {
      expect(find.byType(CupertinoNavigationBarBackButton), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    } else {
      expect(find.byType(CupertinoNavigationBarBackButton), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    }
  });

  testWidgets('Platform-specific buttons follow OS design', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (Platform.isIOS)
                CupertinoButton(
                  onPressed: () {},
                  child: const Text('Action'),
                )
              else
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Action'),
                ),
              const SizedBox(height: 16),
              if (Platform.isIOS)
                CupertinoButton(
                  onPressed: () {},
                  color: CupertinoColors.activeBlue,
                  child: const Text('Primary Action'),
                )
              else
                FilledButton(
                  onPressed: () {},
                  child: const Text('Primary Action'),
                ),
            ],
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    if (Platform.isIOS) {
      expect(find.byType(CupertinoButton), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
    } else {
      expect(find.byType(CupertinoButton), findsNothing);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    }
  });

  testWidgets('Platform-specific dialogs follow OS conventions', (tester) async {
    late BuildContext savedContext;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          savedContext = context;
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (Platform.isIOS) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Confirm Action'),
                        content: const Text('Are you sure?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text('Delete'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Action'),
                        content: const Text('Are you sure?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Show Dialog'),
              ),
            ),
          );
        },
      ),
    ));

    await tester.pumpAndSettle();
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    if (Platform.isIOS) {
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(CupertinoDialogAction), findsNWidgets(2));
    } else {
      expect(find.byType(CupertinoAlertDialog), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
    }
  });

  testWidgets('Platform-specific text selection follows OS conventions', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Platform.isIOS
              ? CupertinoTextField(
                  controller: TextEditingController(),
                  placeholder: 'Enter text',
                )
              : TextField(
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                  ),
                ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    if (Platform.isIOS) {
      expect(find.byType(CupertinoTextField), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    } else {
      expect(find.byType(CupertinoTextField), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
    }

    // Test text selection behavior
    await tester.tap(Platform.isIOS ? find.byType(CupertinoTextField) : find.byType(TextField));
    await tester.pump();

    // Verify selection controls are platform-specific
    final selectableText = Platform.isIOS
        ? find.byType(CupertinoTextField)
        : find.byType(TextField);
    expect(selectableText, findsOneWidget);
  });

  testWidgets('Platform-specific scrolling physics', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          physics: Platform.isIOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
          itemCount: 50,
          itemBuilder: (context, index) => ListTile(
            title: Text('Item $index'),
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    final listView = tester.widget<ListView>(find.byType(ListView));
    if (Platform.isIOS) {
      expect(listView.physics, isA<BouncingScrollPhysics>());
    } else {
      expect(listView.physics, isA<ClampingScrollPhysics>());
    }
  });
}
