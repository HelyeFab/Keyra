import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/features/notifications/services/notification_service.dart';
import 'package:Keyra/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Keyra/features/notifications/presentation/pages/notification_settings_page.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

void main() {
  late NotificationService notificationService;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    notificationService = NotificationService();
  });

  testWidgets('Complete notification settings flow', (tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => NotificationBloc(
            notificationService: notificationService,
          ),
          child: const NotificationSettingsPage(),
        ),
      ),
    );

    // Initially, notifications should be disabled
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    expect(tester.widget<Switch>(switchFinder).value, false);

    // Enable notifications
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verify permission request dialog appears
    expect(find.text(UiTranslations.of(tester.element(find.byType(NotificationSettingsPage))).translate('notifications')), findsOneWidget);

    // After enabling, time picker should be visible
    expect(find.byIcon(Icons.access_time), findsOneWidget);

    // Tap time picker
    await tester.tap(find.byIcon(Icons.access_time));
    await tester.pumpAndSettle();

    // Verify time picker dialog appears
    expect(find.byType(TimePickerDialog), findsOneWidget);

    // Select a time (simulate user selecting 9:00 AM)
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify notification is scheduled
    expect(find.text(UiTranslations.of(tester.element(find.byType(NotificationSettingsPage))).translate('select_notification_time')), findsOneWidget);

    // Disable notifications
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verify notifications are disabled
    expect(tester.widget<Switch>(switchFinder).value, false);
  });

  testWidgets('Notification error handling', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => NotificationBloc(
            notificationService: notificationService,
          ),
          child: const NotificationSettingsPage(),
        ),
      ),
    );

    // Trigger an error by trying to schedule without permissions
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verify error dialog appears
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(UiTranslations.of(tester.element(find.byType(NotificationSettingsPage))).translate('notifications')), findsOneWidget);

    // Dismiss error dialog
    await tester.tap(find.text(UiTranslations.of(tester.element(find.byType(NotificationSettingsPage))).translate('ok')));
    await tester.pumpAndSettle();

    // Verify we're back to initial state
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, false);
  });

  testWidgets('Navigation and state preservation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => NotificationBloc(
            notificationService: notificationService,
          ),
          child: const NotificationSettingsPage(),
        ),
      ),
    );

    // Enable notifications
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Navigate forward again
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => NotificationBloc(
            notificationService: notificationService,
          ),
          child: const NotificationSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify state is preserved
    expect(tester.widget<Switch>(find.byType(Switch)).value, true);
  });
}
