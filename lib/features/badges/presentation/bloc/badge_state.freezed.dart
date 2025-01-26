// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BadgeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BadgeProgress progress) loaded,
    required TResult Function(BadgeProgress progress, BadgeLevel newLevel)
        levelingUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BadgeProgress progress)? loaded,
    TResult? Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BadgeProgress progress)? loaded,
    TResult Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_LevelingUp value) levelingUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_LevelingUp value)? levelingUp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_LevelingUp value)? levelingUp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeStateCopyWith<$Res> {
  factory $BadgeStateCopyWith(
          BadgeState value, $Res Function(BadgeState) then) =
      _$BadgeStateCopyWithImpl<$Res, BadgeState>;
}

/// @nodoc
class _$BadgeStateCopyWithImpl<$Res, $Val extends BadgeState>
    implements $BadgeStateCopyWith<$Res> {
  _$BadgeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$BadgeStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'BadgeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BadgeProgress progress) loaded,
    required TResult Function(BadgeProgress progress, BadgeLevel newLevel)
        levelingUp,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BadgeProgress progress)? loaded,
    TResult? Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BadgeProgress progress)? loaded,
    TResult Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_LevelingUp value) levelingUp,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_LevelingUp value)? levelingUp,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_LevelingUp value)? levelingUp,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements BadgeState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BadgeProgress progress});

  $BadgeProgressCopyWith<$Res> get progress;
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$BadgeStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
  }) {
    return _then(_$LoadedImpl(
      null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BadgeProgress,
    ));
  }

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeProgressCopyWith<$Res> get progress {
    return $BadgeProgressCopyWith<$Res>(_value.progress, (value) {
      return _then(_value.copyWith(progress: value));
    });
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(this.progress);

  @override
  final BadgeProgress progress;

  @override
  String toString() {
    return 'BadgeState.loaded(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BadgeProgress progress) loaded,
    required TResult Function(BadgeProgress progress, BadgeLevel newLevel)
        levelingUp,
  }) {
    return loaded(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BadgeProgress progress)? loaded,
    TResult? Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
  }) {
    return loaded?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BadgeProgress progress)? loaded,
    TResult Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_LevelingUp value) levelingUp,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_LevelingUp value)? levelingUp,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_LevelingUp value)? levelingUp,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements BadgeState {
  const factory _Loaded(final BadgeProgress progress) = _$LoadedImpl;

  BadgeProgress get progress;

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LevelingUpImplCopyWith<$Res> {
  factory _$$LevelingUpImplCopyWith(
          _$LevelingUpImpl value, $Res Function(_$LevelingUpImpl) then) =
      __$$LevelingUpImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BadgeProgress progress, BadgeLevel newLevel});

  $BadgeProgressCopyWith<$Res> get progress;
}

/// @nodoc
class __$$LevelingUpImplCopyWithImpl<$Res>
    extends _$BadgeStateCopyWithImpl<$Res, _$LevelingUpImpl>
    implements _$$LevelingUpImplCopyWith<$Res> {
  __$$LevelingUpImplCopyWithImpl(
      _$LevelingUpImpl _value, $Res Function(_$LevelingUpImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? newLevel = null,
  }) {
    return _then(_$LevelingUpImpl(
      null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as BadgeProgress,
      null == newLevel
          ? _value.newLevel
          : newLevel // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
    ));
  }

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeProgressCopyWith<$Res> get progress {
    return $BadgeProgressCopyWith<$Res>(_value.progress, (value) {
      return _then(_value.copyWith(progress: value));
    });
  }
}

/// @nodoc

class _$LevelingUpImpl implements _LevelingUp {
  const _$LevelingUpImpl(this.progress, this.newLevel);

  @override
  final BadgeProgress progress;
  @override
  final BadgeLevel newLevel;

  @override
  String toString() {
    return 'BadgeState.levelingUp(progress: $progress, newLevel: $newLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelingUpImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.newLevel, newLevel) ||
                other.newLevel == newLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, newLevel);

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelingUpImplCopyWith<_$LevelingUpImpl> get copyWith =>
      __$$LevelingUpImplCopyWithImpl<_$LevelingUpImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BadgeProgress progress) loaded,
    required TResult Function(BadgeProgress progress, BadgeLevel newLevel)
        levelingUp,
  }) {
    return levelingUp(progress, newLevel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BadgeProgress progress)? loaded,
    TResult? Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
  }) {
    return levelingUp?.call(progress, newLevel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BadgeProgress progress)? loaded,
    TResult Function(BadgeProgress progress, BadgeLevel newLevel)? levelingUp,
    required TResult orElse(),
  }) {
    if (levelingUp != null) {
      return levelingUp(progress, newLevel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_LevelingUp value) levelingUp,
  }) {
    return levelingUp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_LevelingUp value)? levelingUp,
  }) {
    return levelingUp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_LevelingUp value)? levelingUp,
    required TResult orElse(),
  }) {
    if (levelingUp != null) {
      return levelingUp(this);
    }
    return orElse();
  }
}

abstract class _LevelingUp implements BadgeState {
  const factory _LevelingUp(
          final BadgeProgress progress, final BadgeLevel newLevel) =
      _$LevelingUpImpl;

  BadgeProgress get progress;
  BadgeLevel get newLevel;

  /// Create a copy of BadgeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelingUpImplCopyWith<_$LevelingUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
