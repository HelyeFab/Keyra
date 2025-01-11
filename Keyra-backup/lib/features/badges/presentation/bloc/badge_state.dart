import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_progress.dart';

part 'badge_state.freezed.dart';

@freezed
class BadgeState with _$BadgeState {
  const factory BadgeState.initial() = _Initial;
  const factory BadgeState.loaded(BadgeProgress progress) = _Loaded;
  const factory BadgeState.levelingUp(BadgeProgress progress, BadgeLevel newLevel) = _LevelingUp;
}
