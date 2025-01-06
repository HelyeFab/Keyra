import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeUtils {
  static DateTime? fromTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.parse(timestamp);
    if (timestamp is Map) {
      if (timestamp['_seconds'] != null && timestamp['_nanoseconds'] != null) {
        return Timestamp(
          timestamp['_seconds'],
          timestamp['_nanoseconds'],
        ).toDate();
      }
    }
    return null;
  }

  static dynamic toTimestamp(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}
