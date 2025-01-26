// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BadgeProgress _$BadgeProgressFromJson(Map<String, dynamic> json) {
  return _BadgeProgress.fromJson(json);
}

/// @nodoc
mixin _$BadgeProgress {
  BadgeLevel get currentLevel => throw _privateConstructorUsedError;
  int get booksRead => throw _privateConstructorUsedError;
  int get favoriteBooks => throw _privateConstructorUsedError;
  int get readingStreak => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this BadgeProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeProgressCopyWith<BadgeProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeProgressCopyWith<$Res> {
  factory $BadgeProgressCopyWith(
          BadgeProgress value, $Res Function(BadgeProgress) then) =
      _$BadgeProgressCopyWithImpl<$Res, BadgeProgress>;
  @useResult
  $Res call(
      {BadgeLevel currentLevel,
      int booksRead,
      int favoriteBooks,
      int readingStreak,
      DateTime lastUpdated});
}

/// @nodoc
class _$BadgeProgressCopyWithImpl<$Res, $Val extends BadgeProgress>
    implements $BadgeProgressCopyWith<$Res> {
  _$BadgeProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLevel = null,
    Object? booksRead = null,
    Object? favoriteBooks = null,
    Object? readingStreak = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
      booksRead: null == booksRead
          ? _value.booksRead
          : booksRead // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteBooks: null == favoriteBooks
          ? _value.favoriteBooks
          : favoriteBooks // ignore: cast_nullable_to_non_nullable
              as int,
      readingStreak: null == readingStreak
          ? _value.readingStreak
          : readingStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeProgressImplCopyWith<$Res>
    implements $BadgeProgressCopyWith<$Res> {
  factory _$$BadgeProgressImplCopyWith(
          _$BadgeProgressImpl value, $Res Function(_$BadgeProgressImpl) then) =
      __$$BadgeProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BadgeLevel currentLevel,
      int booksRead,
      int favoriteBooks,
      int readingStreak,
      DateTime lastUpdated});
}

/// @nodoc
class __$$BadgeProgressImplCopyWithImpl<$Res>
    extends _$BadgeProgressCopyWithImpl<$Res, _$BadgeProgressImpl>
    implements _$$BadgeProgressImplCopyWith<$Res> {
  __$$BadgeProgressImplCopyWithImpl(
      _$BadgeProgressImpl _value, $Res Function(_$BadgeProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLevel = null,
    Object? booksRead = null,
    Object? favoriteBooks = null,
    Object? readingStreak = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$BadgeProgressImpl(
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
      booksRead: null == booksRead
          ? _value.booksRead
          : booksRead // ignore: cast_nullable_to_non_nullable
              as int,
      favoriteBooks: null == favoriteBooks
          ? _value.favoriteBooks
          : favoriteBooks // ignore: cast_nullable_to_non_nullable
              as int,
      readingStreak: null == readingStreak
          ? _value.readingStreak
          : readingStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeProgressImpl implements _BadgeProgress {
  const _$BadgeProgressImpl(
      {required this.currentLevel,
      required this.booksRead,
      required this.favoriteBooks,
      required this.readingStreak,
      required this.lastUpdated});

  factory _$BadgeProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeProgressImplFromJson(json);

  @override
  final BadgeLevel currentLevel;
  @override
  final int booksRead;
  @override
  final int favoriteBooks;
  @override
  final int readingStreak;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'BadgeProgress(currentLevel: $currentLevel, booksRead: $booksRead, favoriteBooks: $favoriteBooks, readingStreak: $readingStreak, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeProgressImpl &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.booksRead, booksRead) ||
                other.booksRead == booksRead) &&
            (identical(other.favoriteBooks, favoriteBooks) ||
                other.favoriteBooks == favoriteBooks) &&
            (identical(other.readingStreak, readingStreak) ||
                other.readingStreak == readingStreak) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentLevel, booksRead,
      favoriteBooks, readingStreak, lastUpdated);

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeProgressImplCopyWith<_$BadgeProgressImpl> get copyWith =>
      __$$BadgeProgressImplCopyWithImpl<_$BadgeProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeProgressImplToJson(
      this,
    );
  }
}

abstract class _BadgeProgress implements BadgeProgress {
  const factory _BadgeProgress(
      {required final BadgeLevel currentLevel,
      required final int booksRead,
      required final int favoriteBooks,
      required final int readingStreak,
      required final DateTime lastUpdated}) = _$BadgeProgressImpl;

  factory _BadgeProgress.fromJson(Map<String, dynamic> json) =
      _$BadgeProgressImpl.fromJson;

  @override
  BadgeLevel get currentLevel;
  @override
  int get booksRead;
  @override
  int get favoriteBooks;
  @override
  int get readingStreak;
  @override
  DateTime get lastUpdated;

  /// Create a copy of BadgeProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeProgressImplCopyWith<_$BadgeProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
