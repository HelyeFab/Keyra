import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/features/common/widgets/circular_stats_card.dart';

void main() {
  testWidgets('CircularStatsCard displays title and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Books Read',
            value: '42',
            progress: 0.42,
          ),
        ),
      ),
    );

    expect(find.text('Books Read'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('CircularStatsCard animates progress changes', (tester) async {
    // Create a key to access the widget later
    final key = GlobalKey<CircularStatsCardState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            key: key,
            title: 'Progress',
            value: '50%',
            progress: 0.5,
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);

    // Update progress
    key.currentState!.updateProgress(0.75);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify animation completed
    final CircularProgressIndicator indicator = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 0.75);
  });

  testWidgets('CircularStatsCard handles zero progress', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Score',
            value: '0',
            progress: 0.0,
          ),
        ),
      ),
    );

    expect(find.text('Score'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    final CircularProgressIndicator indicator = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 0.0);
  });

  testWidgets('CircularStatsCard handles full progress', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Complete',
            value: '100%',
            progress: 1.0,
          ),
        ),
      ),
    );

    expect(find.text('Complete'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);

    final CircularProgressIndicator indicator = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 1.0);
  });

  testWidgets('CircularStatsCard applies custom colors', (tester) async {
    const customColor = Colors.purple;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Custom',
            value: '75%',
            progress: 0.75,
            progressColor: customColor,
          ),
        ),
      ),
    );

    final CircularProgressIndicator indicator = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    expect(
      (indicator.valueColor as AlwaysStoppedAnimation<Color>).value,
      equals(customColor),
    );
  });

  testWidgets('CircularStatsCard handles tap callback', (tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Tappable',
            value: '50%',
            progress: 0.5,
            onTap: () => wasTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CircularStatsCard));
    expect(wasTapped, true);
  });

  testWidgets('CircularStatsCard displays subtitle when provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Main Title',
            subtitle: 'Subtitle Text',
            value: '60%',
            progress: 0.6,
          ),
        ),
      ),
    );

    expect(find.text('Main Title'), findsOneWidget);
    expect(find.text('Subtitle Text'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
  });

  testWidgets('CircularStatsCard handles long text gracefully', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CircularStatsCard(
            title: 'Very Long Title That Should Be Handled Properly',
            value: 'Long Value Text',
            progress: 0.8,
          ),
        ),
      ),
    );

    expect(find.text('Very Long Title That Should Be Handled Properly'), findsOneWidget);
    expect(find.text('Long Value Text'), findsOneWidget);
  });
}
