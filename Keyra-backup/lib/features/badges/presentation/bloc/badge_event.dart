import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/badge_level.dart';

part 'badge_event.freezed.dart';

@freezed
class BadgeEvent with _$BadgeEvent {
  const factory BadgeEvent.started() = _Started;
  const factory BadgeEvent.wordsUpdated(int wordCount) = _WordsUpdated;
  const factory BadgeEvent.levelUp(BadgeLevel newLevel) = _LevelUp;
}
