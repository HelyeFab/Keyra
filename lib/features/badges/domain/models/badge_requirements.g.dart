// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_requirements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeRequirementsImpl _$$BadgeRequirementsImplFromJson(
        Map<String, dynamic> json) =>
    _$BadgeRequirementsImpl(
      level: $enumDecode(_$BadgeLevelEnumMap, json['level']),
      displayName: json['displayName'] as String,
      assetPath: json['assetPath'] as String,
      requiredBooksRead: (json['requiredBooksRead'] as num).toInt(),
      requiredFavoriteBooks: (json['requiredFavoriteBooks'] as num).toInt(),
      requiredReadingStreak: (json['requiredReadingStreak'] as num).toInt(),
    );

Map<String, dynamic> _$$BadgeRequirementsImplToJson(
        _$BadgeRequirementsImpl instance) =>
    <String, dynamic>{
      'level': _$BadgeLevelEnumMap[instance.level]!,
      'displayName': instance.displayName,
      'assetPath': instance.assetPath,
      'requiredBooksRead': instance.requiredBooksRead,
      'requiredFavoriteBooks': instance.requiredFavoriteBooks,
      'requiredReadingStreak': instance.requiredReadingStreak,
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
