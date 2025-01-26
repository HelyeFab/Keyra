import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Keyra/features/notifications/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockNotificationDetails extends Mock implements NotificationDetails {}

class MockInitializationSettings extends Mock implements InitializationSettings {}

class MockAndroidInitializationSettings extends Mock
    implements AndroidInitializationSettings {}

class MockDarwinInitializationSettings extends Mock
    implements DarwinInitializationSettings {}

class MockTZDateTime extends Mock implements tz.TZDateTime {}

void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockNotifications;
  late MockInitializationSettings mockInitSettings;
  late MockAndroidInitializationSettings mockAndroidSettings;
  late MockDarwinInitializationSettings mockDarwinSettings;

  setUpAll(() {
    // Register fallback values for Mocktail
    registerFallbackValue(MockInitializationSettings());
    registerFallbackValue(MockAndroidInitializationSettings());
    registerFallbackValue(MockDarwinInitializationSettings());
    registerFallbackValue(MockNotificationDetails());
    registerFallbackValue(MockTZDateTime());
  });

  setUp(() {
    mockNotifications = MockFlutterLocalNotificationsPlugin();
    mockInitSettings = MockInitializationSettings();
    mockAndroidSettings = MockAndroidInitializationSettings();
    mockDarwinSettings = MockDarwinInitializationSettings();

    // Setup mock initialization settings
    when(() => mockInitSettings.android).thenReturn(mockAndroidSettings);
    when(() => mockInitSettings.iOS).thenReturn(mockDarwinSettings);

    notificationService = NotificationService(
      notificationsPlugin: mockNotifications,
    );
  });

  group('NotificationService Tests', () {
    test('initialize - configures notification settings', () async {
      // Arrange
      when(() => mockNotifications.initialize(any(),
              onDidReceiveNotificationResponse: any(named: 'onDidReceiveNotificationResponse')))
          .thenAnswer((_) async => true);

      // Act
      final result = await notificationService.initialize();

      // Assert
      expect(result, true);
      verify(() => mockNotifications.initialize(
            any(),
            onDidReceiveNotificationResponse: any(named: 'onDidReceiveNotificationResponse'),
          )).called(1);
    });

    test('showNotification - displays immediate notification', () async {
      // Arrange
      const title = 'Test Title';
      const body = 'Test Body';

      when(() => mockNotifications.show(
            any(),
            title,
            body,
            any(),
          )).thenAnswer((_) async {});

      // Act
      await notificationService.showNotification(
        title: title,
        body: body,
      );

      // Assert
      verify(() => mockNotifications.show(
            any(),
            title,
            body,
            any(),
          )).called(1);
    });

    test('scheduleNotification - schedules future notification', () async {
      // Arrange
      const title = 'Scheduled Test';
      const body = 'Scheduled Body';
      final scheduledDate = DateTime.now().add(const Duration(hours: 1));

      when(() => mockNotifications.zonedSchedule(
            any(),
            title,
            body,
            any(),
            any(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          )).thenAnswer((_) async {});

      // Act
      await notificationService.scheduleNotification(
        title: title,
        body: body,
        scheduledDate: scheduledDate,
      );

      // Assert
      verify(() => mockNotifications.zonedSchedule(
            any(),
            title,
            body,
            any(),
            any(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          )).called(1);
    });

    test('cancelNotification - cancels specific notification', () async {
      // Arrange
      const notificationId = 1;
      when(() => mockNotifications.cancel(notificationId))
          .thenAnswer((_) async {});

      // Act
      await notificationService.cancelNotification(notificationId);

      // Assert
      verify(() => mockNotifications.cancel(notificationId)).called(1);
    });

    test('cancelAllNotifications - cancels all notifications', () async {
      // Arrange
      when(() => mockNotifications.cancelAll()).thenAnswer((_) async {});

      // Act
      await notificationService.cancelAllNotifications();

      // Assert
      verify(() => mockNotifications.cancelAll()).called(1);
    });

    test('getNotificationAppLaunchDetails - returns launch details', () async {
      // Arrange
      const mockDetails = NotificationAppLaunchDetails(
        true,
        notificationResponse: NotificationResponse(
          id: 1,
          actionId: 'default',
          input: '',
          notificationResponseType: NotificationResponseType.selectedNotification,
          payload: 'test_payload',
        ),
      );

      when(() => mockNotifications.getNotificationAppLaunchDetails())
          .thenAnswer((_) async => mockDetails);

      // Act
      final result = await notificationService.getNotificationAppLaunchDetails();

      // Assert
      expect(result?.didNotificationLaunchApp, true);
      expect(result?.notificationResponse?.payload, 'test_payload');
      verify(() => mockNotifications.getNotificationAppLaunchDetails())
          .called(1);
    });

    test('getPendingNotifications - returns pending notifications', () async {
      // Arrange
      final pendingNotifications = [
        const PendingNotificationRequest(
          1,
          'Pending Test',
          'Pending Body',
          'test_payload',
        ),
      ];

      when(() => mockNotifications.pendingNotificationRequests())
          .thenAnswer((_) async => pendingNotifications);

      // Act
      final result = await notificationService.getPendingNotifications();

      // Assert
      expect(result.length, 1);
      expect(result.first.title, 'Pending Test');
      verify(() => mockNotifications.pendingNotificationRequests()).called(1);
    });

    test('handles notification permission changes', () async {
      // Arrange
      when(() => mockNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(AndroidFlutterLocalNotificationsPlugin());

      // Act & Assert
      expect(
        () => notificationService.requestPermissions(),
        returnsNormally,
      );
    });

    test('handles notification click', () async {
      // Arrange
      const payload = 'test_payload';
      var wasHandled = false;

      // Act
      notificationService.onNotificationClick = (String? receivedPayload) {
        wasHandled = true;
        expect(receivedPayload, payload);
      };

      await notificationService.handleNotificationResponse(
        const NotificationResponse(
          id: 1,
          actionId: 'default',
          input: '',
          notificationResponseType: NotificationResponseType.selectedNotification,
          payload: payload,
        ),
      );

      // Assert
      expect(wasHandled, true);
    });
  });
}
