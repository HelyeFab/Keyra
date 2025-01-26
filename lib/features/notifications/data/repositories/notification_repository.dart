import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationTimeKey = 'notification_time';
  final SharedPreferences _prefs;

  NotificationRepository(this._prefs);

  Future<bool> areNotificationsEnabled() async {
    return _prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<TimeOfDay> getNotificationTime() async {
    final timeString = _prefs.getString(_notificationTimeKey) ?? '18:00';
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    await _prefs.setString(_notificationTimeKey, timeString);
  }
}
