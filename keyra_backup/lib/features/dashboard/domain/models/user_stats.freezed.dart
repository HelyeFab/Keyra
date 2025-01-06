// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  int get booksRead => throw _privateConstructorUsedError;
  int get favoriteBooks => throw _privateConstructorUsedError;
  int get readingStreak => throw _privateConstructorUsedError;
  int get savedWords => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
  List<DateTime> get readDates => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get sessionStartTime => throw _privateConstructorUsedError;
  bool get isReadingActive => throw _privateConstructorUsedError;
  int get currentSessionMinutes => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get lastReadDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get lastBookId => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {int booksRead,
      int favoriteBooks,
      int readingStreak,
      int savedWords,
      @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
      List<DateTime> readDates,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? sessionStartTime,
      bool isReadingActive,
      int currentSessionMinutes,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? lastReadDate,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? lastUpdated,
      String? lastBookId});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booksRead = null,
    Object? favoriteBooks = null,
    Object? readingStreak = null,
    Object? savedWords = null,
    Object? readDates = null,
    Object? sessionStartTime = freezed,
    Object? isReadingActive = null,
    Object? currentSessionMinutes = null,
    Object? lastReadDate = freezed,
    Object? lastUpdated = freezed,
    Object? lastBookId = freezed,
  }) {
    return _then(_value.copyWith(
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
      savedWords: null == savedWords
          ? _value.savedWords
          : savedWords // ignore: cast_nullable_to_non_nullable
              as int,
      readDates: null == readDates
          ? _value.readDates
          : readDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      sessionStartTime: freezed == sessionStartTime
          ? _value.sessionStartTime
          : sessionStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isReadingActive: null == isReadingActive
          ? _value.isReadingActive
          : isReadingActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionMinutes: null == currentSessionMinutes
          ? _value.currentSessionMinutes
          : currentSessionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadDate: freezed == lastReadDate
          ? _value.lastReadDate
          : lastReadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastBookId: freezed == lastBookId
          ? _value.lastBookId
          : lastBookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int booksRead,
      int favoriteBooks,
      int readingStreak,
      int savedWords,
      @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
      List<DateTime> readDates,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? sessionStartTime,
      bool isReadingActive,
      int currentSessionMinutes,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? lastReadDate,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      DateTime? lastUpdated,
      String? lastBookId});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booksRead = null,
    Object? favoriteBooks = null,
    Object? readingStreak = null,
    Object? savedWords = null,
    Object? readDates = null,
    Object? sessionStartTime = freezed,
    Object? isReadingActive = null,
    Object? currentSessionMinutes = null,
    Object? lastReadDate = freezed,
    Object? lastUpdated = freezed,
    Object? lastBookId = freezed,
  }) {
    return _then(_$UserStatsImpl(
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
      savedWords: null == savedWords
          ? _value.savedWords
          : savedWords // ignore: cast_nullable_to_non_nullable
              as int,
      readDates: null == readDates
          ? _value._readDates
          : readDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      sessionStartTime: freezed == sessionStartTime
          ? _value.sessionStartTime
          : sessionStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isReadingActive: null == isReadingActive
          ? _value.isReadingActive
          : isReadingActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionMinutes: null == currentSessionMinutes
          ? _value.currentSessionMinutes
          : currentSessionMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadDate: freezed == lastReadDate
          ? _value.lastReadDate
          : lastReadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastBookId: freezed == lastBookId
          ? _value.lastBookId
          : lastBookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl extends _UserStats {
  const _$UserStatsImpl(
      {this.booksRead = 0,
      this.favoriteBooks = 0,
      this.readingStreak = 0,
      this.savedWords = 0,
      @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
      final List<DateTime> readDates = const <DateTime>[],
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      this.sessionStartTime,
      this.isReadingActive = false,
      this.currentSessionMinutes = 0,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      this.lastReadDate,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      this.lastUpdated,
      this.lastBookId})
      : _readDates = readDates,
        super._();

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey()
  final int booksRead;
  @override
  @JsonKey()
  final int favoriteBooks;
  @override
  @JsonKey()
  final int readingStreak;
  @override
  @JsonKey()
  final int savedWords;
  final List<DateTime> _readDates;
  @override
  @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
  List<DateTime> get readDates {
    if (_readDates is EqualUnmodifiableListView) return _readDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readDates);
  }

  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  final DateTime? sessionStartTime;
  @override
  @JsonKey()
  final bool isReadingActive;
  @override
  @JsonKey()
  final int currentSessionMinutes;
  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  final DateTime? lastReadDate;
  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  final DateTime? lastUpdated;
  @override
  final String? lastBookId;

  @override
  String toString() {
    return 'UserStats(booksRead: $booksRead, favoriteBooks: $favoriteBooks, readingStreak: $readingStreak, savedWords: $savedWords, readDates: $readDates, sessionStartTime: $sessionStartTime, isReadingActive: $isReadingActive, currentSessionMinutes: $currentSessionMinutes, lastReadDate: $lastReadDate, lastUpdated: $lastUpdated, lastBookId: $lastBookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.booksRead, booksRead) ||
                other.booksRead == booksRead) &&
            (identical(other.favoriteBooks, favoriteBooks) ||
                other.favoriteBooks == favoriteBooks) &&
            (identical(other.readingStreak, readingStreak) ||
                other.readingStreak == readingStreak) &&
            (identical(other.savedWords, savedWords) ||
                other.savedWords == savedWords) &&
            const DeepCollectionEquality()
                .equals(other._readDates, _readDates) &&
            (identical(other.sessionStartTime, sessionStartTime) ||
                other.sessionStartTime == sessionStartTime) &&
            (identical(other.isReadingActive, isReadingActive) ||
                other.isReadingActive == isReadingActive) &&
            (identical(other.currentSessionMinutes, currentSessionMinutes) ||
                other.currentSessionMinutes == currentSessionMinutes) &&
            (identical(other.lastReadDate, lastReadDate) ||
                other.lastReadDate == lastReadDate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.lastBookId, lastBookId) ||
                other.lastBookId == lastBookId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      booksRead,
      favoriteBooks,
      readingStreak,
      savedWords,
      const DeepCollectionEquality().hash(_readDates),
      sessionStartTime,
      isReadingActive,
      currentSessionMinutes,
      lastReadDate,
      lastUpdated,
      lastBookId);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats extends UserStats {
  const factory _UserStats(
      {final int booksRead,
      final int favoriteBooks,
      final int readingStreak,
      final int savedWords,
      @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
      final List<DateTime> readDates,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      final DateTime? sessionStartTime,
      final bool isReadingActive,
      final int currentSessionMinutes,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      final DateTime? lastReadDate,
      @JsonKey(
          fromJson: DateTimeUtils.fromTimestamp,
          toJson: DateTimeUtils.toTimestamp)
      final DateTime? lastUpdated,
      final String? lastBookId}) = _$UserStatsImpl;
  const _UserStats._() : super._();

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  int get booksRead;
  @override
  int get favoriteBooks;
  @override
  int get readingStreak;
  @override
  int get savedWords;
  @override
  @JsonKey(fromJson: _dateTimeListFromJson, toJson: _dateTimeListToJson)
  List<DateTime> get readDates;
  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get sessionStartTime;
  @override
  bool get isReadingActive;
  @override
  int get currentSessionMinutes;
  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get lastReadDate;
  @override
  @JsonKey(
      fromJson: DateTimeUtils.fromTimestamp, toJson: DateTimeUtils.toTimestamp)
  DateTime? get lastUpdated;
  @override
  String? get lastBookId;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
