// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      booksRead: (json['booksRead'] as num?)?.toInt() ?? 0,
      favoriteBooks: (json['favoriteBooks'] as num?)?.toInt() ?? 0,
      readingStreak: (json['readingStreak'] as num?)?.toInt() ?? 0,
      savedWords: (json['savedWords'] as num?)?.toInt() ?? 0,
      readDates: json['readDates'] == null
          ? const <DateTime>[]
          : _dateTimeListFromJson(json['readDates']),
      sessionStartTime: DateTimeUtils.fromTimestamp(json['sessionStartTime']),
      isReadingActive: json['isReadingActive'] as bool? ?? false,
      currentSessionMinutes:
          (json['currentSessionMinutes'] as num?)?.toInt() ?? 0,
      lastReadDate: DateTimeUtils.fromTimestamp(json['lastReadDate']),
      lastUpdated: DateTimeUtils.fromTimestamp(json['lastUpdated']),
      lastBookId: json['lastBookId'] as String?,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'booksRead': instance.booksRead,
      'favoriteBooks': instance.favoriteBooks,
      'readingStreak': instance.readingStreak,
      'savedWords': instance.savedWords,
      'readDates': _dateTimeListToJson(instance.readDates),
      'sessionStartTime': DateTimeUtils.toTimestamp(instance.sessionStartTime),
      'isReadingActive': instance.isReadingActive,
      'currentSessionMinutes': instance.currentSessionMinutes,
      'lastReadDate': DateTimeUtils.toTimestamp(instance.lastReadDate),
      'lastUpdated': DateTimeUtils.toTimestamp(instance.lastUpdated),
      'lastBookId': instance.lastBookId,
    };
