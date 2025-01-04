import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/datetime_utils.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int booksRead,
    @Default(0) int favoriteBooks,
    @Default(0) int readingStreak,
    @Default(0) int savedWords,
    @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
    @Default(<DateTime>[]) List<DateTime> readDates,
    @JsonKey(fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
    DateTime? sessionStartTime,
    @Default(false) bool isReadingActive,
    @Default(0) int currentSessionMinutes,
    @JsonKey(fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
    DateTime? lastReadDate,
    @JsonKey(fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
    DateTime? lastUpdated,
    String? lastBookId,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  factory UserStats.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    [SnapshotOptions? options]
  ) {
    final data = snapshot.data();
    return data == null ? const UserStats() : UserStats.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    // Ensure booksRead is a number
    if (json['booksRead'] != null) {
      json['booksRead'] = (json['booksRead'] as num).toInt();
    }
    return json;
  }

  const UserStats._();

  bool isStreakActive() {
    if (lastReadDate == null) return false;

    final now = DateTime.now();
    final yesterday = DateTime(
      now.year,
      now.month,
      now.day - 1,
    );

    final lastRead = DateTime(
      lastReadDate!.year,
      lastReadDate!.month,
      lastReadDate!.day,
    );

    return lastRead.isAtSameMomentAs(yesterday) || lastRead.isAtSameMomentAs(now);
  }
}

List<DateTime> _dateTimeListFromJson(dynamic json) {
  if (json == null) return [];
  if (json is! List) return [];
  
  return json.map((item) {
    if (item is Timestamp) {
      return item.toDate();
    }
    if (item is String) {
      return DateTime.parse(item);
    }
    if (item is Map) {
      if (item['_seconds'] != null && item['_nanoseconds'] != null) {
        return Timestamp(item['_seconds'], item['_nanoseconds']).toDate();
      }
    }
    return DateTime.now(); // fallback
  }).toList();
}

List<dynamic> _dateTimeListToJson(List<DateTime> dates) {
  return dates.map((date) => Timestamp.fromDate(date)).toList();
}
