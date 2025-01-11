// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeProgressImpl _$$BadgeProgressImplFromJson(Map<String, dynamic> json) =>
    _$BadgeProgressImpl(
      currentLevel: $enumDecode(_$BadgeLevelEnumMap, json['currentLevel']),
      booksRead: (json['booksRead'] as num).toInt(),
      favoriteBooks: (json['favoriteBooks'] as num).toInt(),
      readingStreak: (json['readingStreak'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$BadgeProgressImplToJson(_$BadgeProgressImpl instance) =>
    <String, dynamic>{
      'currentLevel': _$BadgeLevelEnumMap[instance.currentLevel]!,
      'booksRead': instance.booksRead,
      'favoriteBooks': instance.favoriteBooks,
      'readingStreak': instance.readingStreak,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$BadgeLevelEnumMap = {
  BadgeLevel.beginner: 'beginner',
  BadgeLevel.intermediate: 'intermediate',
  BadgeLevel.advanced: 'advanced',
  BadgeLevel.master: 'master',
  BadgeLevel.explorer: 'explorer',
  BadgeLevel.voyager: 'voyager',
  BadgeLevel.weaver: 'weaver',
  BadgeLevel.navigator: 'navigator',
  BadgeLevel.pioneer: 'pioneer',
  BadgeLevel.royalty: 'royalty',
  BadgeLevel.baron: 'baron',
  BadgeLevel.legend: 'legend',
  BadgeLevel.wizard: 'wizard',
  BadgeLevel.epic: 'epic',
  BadgeLevel.titan: 'titan',
  BadgeLevel.sovereign: 'sovereign',
  BadgeLevel.virtuoso: 'virtuoso',
  BadgeLevel.luminary: 'luminary',
  BadgeLevel.beacon: 'beacon',
  BadgeLevel.radiant: 'radiant',
  BadgeLevel.lighthouse: 'lighthouse',
  BadgeLevel.infinite: 'infinite',
  BadgeLevel.renaissance: 'renaissance',
  BadgeLevel.ultimate: 'ultimate',
};
