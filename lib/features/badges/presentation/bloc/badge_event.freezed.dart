// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BadgeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(int wordCount) wordsUpdated,
    required TResult Function(BadgeLevel newLevel) levelUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(int wordCount)? wordsUpdated,
    TResult? Function(BadgeLevel newLevel)? levelUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(int wordCount)? wordsUpdated,
    TResult Function(BadgeLevel newLevel)? levelUp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_WordsUpdated value) wordsUpdated,
    required TResult Function(_LevelUp value) levelUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_WordsUpdated value)? wordsUpdated,
    TResult? Function(_LevelUp value)? levelUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_WordsUpdated value)? wordsUpdated,
    TResult Function(_LevelUp value)? levelUp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeEventCopyWith<$Res> {
  factory $BadgeEventCopyWith(
          BadgeEvent value, $Res Function(BadgeEvent) then) =
      _$BadgeEventCopyWithImpl<$Res, BadgeEvent>;
}

/// @nodoc
class _$BadgeEventCopyWithImpl<$Res, $Val extends BadgeEvent>
    implements $BadgeEventCopyWith<$Res> {
  _$BadgeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$BadgeEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'BadgeEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(int wordCount) wordsUpdated,
    required TResult Function(BadgeLevel newLevel) levelUp,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(int wordCount)? wordsUpdated,
    TResult? Function(BadgeLevel newLevel)? levelUp,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(int wordCount)? wordsUpdated,
    TResult Function(BadgeLevel newLevel)? levelUp,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_WordsUpdated value) wordsUpdated,
    required TResult Function(_LevelUp value) levelUp,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_WordsUpdated value)? wordsUpdated,
    TResult? Function(_LevelUp value)? levelUp,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_WordsUpdated value)? wordsUpdated,
    TResult Function(_LevelUp value)? levelUp,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements BadgeEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$WordsUpdatedImplCopyWith<$Res> {
  factory _$$WordsUpdatedImplCopyWith(
          _$WordsUpdatedImpl value, $Res Function(_$WordsUpdatedImpl) then) =
      __$$WordsUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int wordCount});
}

/// @nodoc
class __$$WordsUpdatedImplCopyWithImpl<$Res>
    extends _$BadgeEventCopyWithImpl<$Res, _$WordsUpdatedImpl>
    implements _$$WordsUpdatedImplCopyWith<$Res> {
  __$$WordsUpdatedImplCopyWithImpl(
      _$WordsUpdatedImpl _value, $Res Function(_$WordsUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordCount = null,
  }) {
    return _then(_$WordsUpdatedImpl(
      null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WordsUpdatedImpl implements _WordsUpdated {
  const _$WordsUpdatedImpl(this.wordCount);

  @override
  final int wordCount;

  @override
  String toString() {
    return 'BadgeEvent.wordsUpdated(wordCount: $wordCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordsUpdatedImpl &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, wordCount);

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordsUpdatedImplCopyWith<_$WordsUpdatedImpl> get copyWith =>
      __$$WordsUpdatedImplCopyWithImpl<_$WordsUpdatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(int wordCount) wordsUpdated,
    required TResult Function(BadgeLevel newLevel) levelUp,
  }) {
    return wordsUpdated(wordCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(int wordCount)? wordsUpdated,
    TResult? Function(BadgeLevel newLevel)? levelUp,
  }) {
    return wordsUpdated?.call(wordCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(int wordCount)? wordsUpdated,
    TResult Function(BadgeLevel newLevel)? levelUp,
    required TResult orElse(),
  }) {
    if (wordsUpdated != null) {
      return wordsUpdated(wordCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_WordsUpdated value) wordsUpdated,
    required TResult Function(_LevelUp value) levelUp,
  }) {
    return wordsUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_WordsUpdated value)? wordsUpdated,
    TResult? Function(_LevelUp value)? levelUp,
  }) {
    return wordsUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_WordsUpdated value)? wordsUpdated,
    TResult Function(_LevelUp value)? levelUp,
    required TResult orElse(),
  }) {
    if (wordsUpdated != null) {
      return wordsUpdated(this);
    }
    return orElse();
  }
}

abstract class _WordsUpdated implements BadgeEvent {
  const factory _WordsUpdated(final int wordCount) = _$WordsUpdatedImpl;

  int get wordCount;

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordsUpdatedImplCopyWith<_$WordsUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelUpImplCopyWith<$Res> {
  factory _$$LevelUpImplCopyWith(
          _$LevelUpImpl value, $Res Function(_$LevelUpImpl) then) =
      __$$LevelUpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BadgeLevel newLevel});
}

/// @nodoc
class __$$LevelUpImplCopyWithImpl<$Res>
    extends _$BadgeEventCopyWithImpl<$Res, _$LevelUpImpl>
    implements _$$LevelUpImplCopyWith<$Res> {
  __$$LevelUpImplCopyWithImpl(
      _$LevelUpImpl _value, $Res Function(_$LevelUpImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newLevel = null,
  }) {
    return _then(_$LevelUpImpl(
      null == newLevel
          ? _value.newLevel
          : newLevel // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
    ));
  }
}

/// @nodoc

class _$LevelUpImpl implements _LevelUp {
  const _$LevelUpImpl(this.newLevel);

  @override
  final BadgeLevel newLevel;

  @override
  String toString() {
    return 'BadgeEvent.levelUp(newLevel: $newLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelUpImpl &&
            (identical(other.newLevel, newLevel) ||
                other.newLevel == newLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newLevel);

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelUpImplCopyWith<_$LevelUpImpl> get copyWith =>
      __$$LevelUpImplCopyWithImpl<_$LevelUpImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(int wordCount) wordsUpdated,
    required TResult Function(BadgeLevel newLevel) levelUp,
  }) {
    return levelUp(newLevel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(int wordCount)? wordsUpdated,
    TResult? Function(BadgeLevel newLevel)? levelUp,
  }) {
    return levelUp?.call(newLevel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(int wordCount)? wordsUpdated,
    TResult Function(BadgeLevel newLevel)? levelUp,
    required TResult orElse(),
  }) {
    if (levelUp != null) {
      return levelUp(newLevel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_WordsUpdated value) wordsUpdated,
    required TResult Function(_LevelUp value) levelUp,
  }) {
    return levelUp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_WordsUpdated value)? wordsUpdated,
    TResult? Function(_LevelUp value)? levelUp,
  }) {
    return levelUp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_WordsUpdated value)? wordsUpdated,
    TResult Function(_LevelUp value)? levelUp,
    required TResult orElse(),
  }) {
    if (levelUp != null) {
      return levelUp(this);
    }
    return orElse();
  }
}

abstract class _LevelUp implements BadgeEvent {
  const factory _LevelUp(final BadgeLevel newLevel) = _$LevelUpImpl;

  BadgeLevel get newLevel;

  /// Create a copy of BadgeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelUpImplCopyWith<_$LevelUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
