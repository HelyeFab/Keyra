// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedWordImpl _$$SavedWordImplFromJson(Map<String, dynamic> json) =>
    _$SavedWordImpl(
      id: json['id'] as String,
      word: json['word'] as String,
      definition: json['definition'] as String,
      language: json['language'] as String,
      examples:
          (json['examples'] as List<dynamic>).map((e) => e as String).toList(),
      savedAt: _timestampToDateTime(json['savedAt'] as Timestamp),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 0,
      lastReviewed:
          _nullableTimestampToDateTime(json['lastReviewed'] as Timestamp?),
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      easeFactor: (json['easeFactor'] as num?)?.toDouble() ?? 2.5,
      interval: (json['interval'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$SavedWordImplToJson(_$SavedWordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'definition': instance.definition,
      'language': instance.language,
      'examples': instance.examples,
      'savedAt': _dateTimeToTimestamp(instance.savedAt),
      'progress': instance.progress,
      'difficulty': instance.difficulty,
      'lastReviewed': _nullableDateTimeToTimestamp(instance.lastReviewed),
      'repetitions': instance.repetitions,
      'easeFactor': instance.easeFactor,
      'interval': instance.interval,
    };
