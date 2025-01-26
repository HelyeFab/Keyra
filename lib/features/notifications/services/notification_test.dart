import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationTester {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_notification',
      'Test Notifications',
      channelDescription: 'Channel for testing notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_stat_notification',
      color: Color(0xFF007AFF),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      'Test Notification',
      'This is a test notification to verify the icon display',
      notificationDetails,
    );
  }
}
