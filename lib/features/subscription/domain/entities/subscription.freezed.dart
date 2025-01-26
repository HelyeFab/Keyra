// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
  SubscriptionTier get tier => throw _privateConstructorUsedError;
  @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get lastLimitIncrease => throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  bool get autoRenew => throw _privateConstructorUsedError;
  int get bookLimit => throw _privateConstructorUsedError;
  int get booksRead => throw _privateConstructorUsedError;
  List<String> get readBookIds => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
      SubscriptionTier tier,
      @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
      SubscriptionStatus status,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime startDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime endDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime lastLimitIncrease,
      String? paymentId,
      bool autoRenew,
      int bookLimit,
      int booksRead,
      List<String> readBookIds});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? lastLimitIncrease = null,
    Object? paymentId = freezed,
    Object? autoRenew = null,
    Object? bookLimit = null,
    Object? booksRead = null,
    Object? readBookIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLimitIncrease: null == lastLimitIncrease
          ? _value.lastLimitIncrease
          : lastLimitIncrease // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      bookLimit: null == bookLimit
          ? _value.bookLimit
          : bookLimit // ignore: cast_nullable_to_non_nullable
              as int,
      booksRead: null == booksRead
          ? _value.booksRead
          : booksRead // ignore: cast_nullable_to_non_nullable
              as int,
      readBookIds: null == readBookIds
          ? _value.readBookIds
          : readBookIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
      SubscriptionTier tier,
      @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
      SubscriptionStatus status,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime startDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime endDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      DateTime lastLimitIncrease,
      String? paymentId,
      bool autoRenew,
      int bookLimit,
      int booksRead,
      List<String> readBookIds});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? lastLimitIncrease = null,
    Object? paymentId = freezed,
    Object? autoRenew = null,
    Object? bookLimit = null,
    Object? booksRead = null,
    Object? readBookIds = null,
  }) {
    return _then(_$SubscriptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLimitIncrease: null == lastLimitIncrease
          ? _value.lastLimitIncrease
          : lastLimitIncrease // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      bookLimit: null == bookLimit
          ? _value.bookLimit
          : bookLimit // ignore: cast_nullable_to_non_nullable
              as int,
      booksRead: null == booksRead
          ? _value.booksRead
          : booksRead // ignore: cast_nullable_to_non_nullable
              as int,
      readBookIds: null == readBookIds
          ? _value._readBookIds
          : readBookIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl extends _Subscription {
  const _$SubscriptionImpl(
      {required this.id,
      required this.userId,
      @JsonKey(fromJson: tierFromJson, toJson: tierToJson) required this.tier,
      @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
      required this.status,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required this.startDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required this.endDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required this.lastLimitIncrease,
      this.paymentId,
      this.autoRenew = false,
      this.bookLimit = 10,
      this.booksRead = 0,
      final List<String> readBookIds = const []})
      : _readBookIds = readBookIds,
        super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
  final SubscriptionTier tier;
  @override
  @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
  final SubscriptionStatus status;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  final DateTime startDate;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  final DateTime endDate;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  final DateTime lastLimitIncrease;
  @override
  final String? paymentId;
  @override
  @JsonKey()
  final bool autoRenew;
  @override
  @JsonKey()
  final int bookLimit;
  @override
  @JsonKey()
  final int booksRead;
  final List<String> _readBookIds;
  @override
  @JsonKey()
  List<String> get readBookIds {
    if (_readBookIds is EqualUnmodifiableListView) return _readBookIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readBookIds);
  }

  @override
  String toString() {
    return 'Subscription(id: $id, userId: $userId, tier: $tier, status: $status, startDate: $startDate, endDate: $endDate, lastLimitIncrease: $lastLimitIncrease, paymentId: $paymentId, autoRenew: $autoRenew, bookLimit: $bookLimit, booksRead: $booksRead, readBookIds: $readBookIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.lastLimitIncrease, lastLimitIncrease) ||
                other.lastLimitIncrease == lastLimitIncrease) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.bookLimit, bookLimit) ||
                other.bookLimit == bookLimit) &&
            (identical(other.booksRead, booksRead) ||
                other.booksRead == booksRead) &&
            const DeepCollectionEquality()
                .equals(other._readBookIds, _readBookIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      tier,
      status,
      startDate,
      endDate,
      lastLimitIncrease,
      paymentId,
      autoRenew,
      bookLimit,
      booksRead,
      const DeepCollectionEquality().hash(_readBookIds));

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription extends Subscription {
  const factory _Subscription(
      {required final String id,
      required final String userId,
      @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
      required final SubscriptionTier tier,
      @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
      required final SubscriptionStatus status,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required final DateTime startDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required final DateTime endDate,
      @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
      required final DateTime lastLimitIncrease,
      final String? paymentId,
      final bool autoRenew,
      final int bookLimit,
      final int booksRead,
      final List<String> readBookIds}) = _$SubscriptionImpl;
  const _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  @JsonKey(fromJson: tierFromJson, toJson: tierToJson)
  SubscriptionTier get tier;
  @override
  @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
  SubscriptionStatus get status;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get startDate;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get endDate;
  @override
  @JsonKey(fromJson: dateTimeFromTimestamp, toJson: dateTimeToTimestamp)
  DateTime get lastLimitIncrease;
  @override
  String? get paymentId;
  @override
  bool get autoRenew;
  @override
  int get bookLimit;
  @override
  int get booksRead;
  @override
  List<String> get readBookIds;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
