// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_requirements.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BadgeRequirements _$BadgeRequirementsFromJson(Map<String, dynamic> json) {
  return _BadgeRequirements.fromJson(json);
}

/// @nodoc
mixin _$BadgeRequirements {
  BadgeLevel get level => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get assetPath => throw _privateConstructorUsedError;
  int get requiredBooksRead => throw _privateConstructorUsedError;
  int get requiredFavoriteBooks => throw _privateConstructorUsedError;
  int get requiredReadingStreak => throw _privateConstructorUsedError;

  /// Serializes this BadgeRequirements to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BadgeRequirements
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeRequirementsCopyWith<BadgeRequirements> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeRequirementsCopyWith<$Res> {
  factory $BadgeRequirementsCopyWith(
          BadgeRequirements value, $Res Function(BadgeRequirements) then) =
      _$BadgeRequirementsCopyWithImpl<$Res, BadgeRequirements>;
  @useResult
  $Res call(
      {BadgeLevel level,
      String displayName,
      String assetPath,
      int requiredBooksRead,
      int requiredFavoriteBooks,
      int requiredReadingStreak});
}

/// @nodoc
class _$BadgeRequirementsCopyWithImpl<$Res, $Val extends BadgeRequirements>
    implements $BadgeRequirementsCopyWith<$Res> {
  _$BadgeRequirementsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BadgeRequirements
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? displayName = null,
    Object? assetPath = null,
    Object? requiredBooksRead = null,
    Object? requiredFavoriteBooks = null,
    Object? requiredReadingStreak = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      assetPath: null == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String,
      requiredBooksRead: null == requiredBooksRead
          ? _value.requiredBooksRead
          : requiredBooksRead // ignore: cast_nullable_to_non_nullable
              as int,
      requiredFavoriteBooks: null == requiredFavoriteBooks
          ? _value.requiredFavoriteBooks
          : requiredFavoriteBooks // ignore: cast_nullable_to_non_nullable
              as int,
      requiredReadingStreak: null == requiredReadingStreak
          ? _value.requiredReadingStreak
          : requiredReadingStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeRequirementsImplCopyWith<$Res>
    implements $BadgeRequirementsCopyWith<$Res> {
  factory _$$BadgeRequirementsImplCopyWith(_$BadgeRequirementsImpl value,
          $Res Function(_$BadgeRequirementsImpl) then) =
      __$$BadgeRequirementsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BadgeLevel level,
      String displayName,
      String assetPath,
      int requiredBooksRead,
      int requiredFavoriteBooks,
      int requiredReadingStreak});
}

/// @nodoc
class __$$BadgeRequirementsImplCopyWithImpl<$Res>
    extends _$BadgeRequirementsCopyWithImpl<$Res, _$BadgeRequirementsImpl>
    implements _$$BadgeRequirementsImplCopyWith<$Res> {
  __$$BadgeRequirementsImplCopyWithImpl(_$BadgeRequirementsImpl _value,
      $Res Function(_$BadgeRequirementsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BadgeRequirements
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? displayName = null,
    Object? assetPath = null,
    Object? requiredBooksRead = null,
    Object? requiredFavoriteBooks = null,
    Object? requiredReadingStreak = null,
  }) {
    return _then(_$BadgeRequirementsImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as BadgeLevel,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      assetPath: null == assetPath
          ? _value.assetPath
          : assetPath // ignore: cast_nullable_to_non_nullable
              as String,
      requiredBooksRead: null == requiredBooksRead
          ? _value.requiredBooksRead
          : requiredBooksRead // ignore: cast_nullable_to_non_nullable
              as int,
      requiredFavoriteBooks: null == requiredFavoriteBooks
          ? _value.requiredFavoriteBooks
          : requiredFavoriteBooks // ignore: cast_nullable_to_non_nullable
              as int,
      requiredReadingStreak: null == requiredReadingStreak
          ? _value.requiredReadingStreak
          : requiredReadingStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeRequirementsImpl extends _BadgeRequirements {
  const _$BadgeRequirementsImpl(
      {required this.level,
      required this.displayName,
      required this.assetPath,
      required this.requiredBooksRead,
      required this.requiredFavoriteBooks,
      required this.requiredReadingStreak})
      : super._();

  factory _$BadgeRequirementsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeRequirementsImplFromJson(json);

  @override
  final BadgeLevel level;
  @override
  final String displayName;
  @override
  final String assetPath;
  @override
  final int requiredBooksRead;
  @override
  final int requiredFavoriteBooks;
  @override
  final int requiredReadingStreak;

  @override
  String toString() {
    return 'BadgeRequirements(level: $level, displayName: $displayName, assetPath: $assetPath, requiredBooksRead: $requiredBooksRead, requiredFavoriteBooks: $requiredFavoriteBooks, requiredReadingStreak: $requiredReadingStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeRequirementsImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.assetPath, assetPath) ||
                other.assetPath == assetPath) &&
            (identical(other.requiredBooksRead, requiredBooksRead) ||
                other.requiredBooksRead == requiredBooksRead) &&
            (identical(other.requiredFavoriteBooks, requiredFavoriteBooks) ||
                other.requiredFavoriteBooks == requiredFavoriteBooks) &&
            (identical(other.requiredReadingStreak, requiredReadingStreak) ||
                other.requiredReadingStreak == requiredReadingStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, displayName, assetPath,
      requiredBooksRead, requiredFavoriteBooks, requiredReadingStreak);

  /// Create a copy of BadgeRequirements
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeRequirementsImplCopyWith<_$BadgeRequirementsImpl> get copyWith =>
      __$$BadgeRequirementsImplCopyWithImpl<_$BadgeRequirementsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeRequirementsImplToJson(
      this,
    );
  }
}

abstract class _BadgeRequirements extends BadgeRequirements {
  const factory _BadgeRequirements(
      {required final BadgeLevel level,
      required final String displayName,
      required final String assetPath,
      required final int requiredBooksRead,
      required final int requiredFavoriteBooks,
      required final int requiredReadingStreak}) = _$BadgeRequirementsImpl;
  const _BadgeRequirements._() : super._();

  factory _BadgeRequirements.fromJson(Map<String, dynamic> json) =
      _$BadgeRequirementsImpl.fromJson;

  @override
  BadgeLevel get level;
  @override
  String get displayName;
  @override
  String get assetPath;
  @override
  int get requiredBooksRead;
  @override
  int get requiredFavoriteBooks;
  @override
  int get requiredReadingStreak;

  /// Create a copy of BadgeRequirements
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeRequirementsImplCopyWith<_$BadgeRequirementsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
