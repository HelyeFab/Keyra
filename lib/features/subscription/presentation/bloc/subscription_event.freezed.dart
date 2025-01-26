// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionEventCopyWith(
          SubscriptionEvent value, $Res Function(SubscriptionEvent) then) =
      _$SubscriptionEventCopyWithImpl<$Res, SubscriptionEvent>;
}

/// @nodoc
class _$SubscriptionEventCopyWithImpl<$Res, $Val extends SubscriptionEvent>
    implements $SubscriptionEventCopyWith<$Res> {
  _$SubscriptionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionEvent
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
    extends _$SubscriptionEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'SubscriptionEvent.started()';
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
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
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
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements SubscriptionEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$UpgradedImplCopyWith<$Res> {
  factory _$$UpgradedImplCopyWith(
          _$UpgradedImpl value, $Res Function(_$UpgradedImpl) then) =
      __$$UpgradedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpgradedImplCopyWithImpl<$Res>
    extends _$SubscriptionEventCopyWithImpl<$Res, _$UpgradedImpl>
    implements _$$UpgradedImplCopyWith<$Res> {
  __$$UpgradedImplCopyWithImpl(
      _$UpgradedImpl _value, $Res Function(_$UpgradedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpgradedImpl implements _Upgraded {
  const _$UpgradedImpl();

  @override
  String toString() {
    return 'SubscriptionEvent.upgraded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpgradedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) {
    return upgraded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) {
    return upgraded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (upgraded != null) {
      return upgraded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) {
    return upgraded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) {
    return upgraded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) {
    if (upgraded != null) {
      return upgraded(this);
    }
    return orElse();
  }
}

abstract class _Upgraded implements SubscriptionEvent {
  const factory _Upgraded() = _$UpgradedImpl;
}

/// @nodoc
abstract class _$$CancelledImplCopyWith<$Res> {
  factory _$$CancelledImplCopyWith(
          _$CancelledImpl value, $Res Function(_$CancelledImpl) then) =
      __$$CancelledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CancelledImplCopyWithImpl<$Res>
    extends _$SubscriptionEventCopyWithImpl<$Res, _$CancelledImpl>
    implements _$$CancelledImplCopyWith<$Res> {
  __$$CancelledImplCopyWithImpl(
      _$CancelledImpl _value, $Res Function(_$CancelledImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CancelledImpl implements _Cancelled {
  const _$CancelledImpl();

  @override
  String toString() {
    return 'SubscriptionEvent.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CancelledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class _Cancelled implements SubscriptionEvent {
  const factory _Cancelled() = _$CancelledImpl;
}

/// @nodoc
abstract class _$$RenewedImplCopyWith<$Res> {
  factory _$$RenewedImplCopyWith(
          _$RenewedImpl value, $Res Function(_$RenewedImpl) then) =
      __$$RenewedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RenewedImplCopyWithImpl<$Res>
    extends _$SubscriptionEventCopyWithImpl<$Res, _$RenewedImpl>
    implements _$$RenewedImplCopyWith<$Res> {
  __$$RenewedImplCopyWithImpl(
      _$RenewedImpl _value, $Res Function(_$RenewedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RenewedImpl implements _Renewed {
  const _$RenewedImpl();

  @override
  String toString() {
    return 'SubscriptionEvent.renewed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RenewedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) {
    return renewed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) {
    return renewed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (renewed != null) {
      return renewed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) {
    return renewed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) {
    return renewed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) {
    if (renewed != null) {
      return renewed(this);
    }
    return orElse();
  }
}

abstract class _Renewed implements SubscriptionEvent {
  const factory _Renewed() = _$RenewedImpl;
}

/// @nodoc
abstract class _$$RestoredImplCopyWith<$Res> {
  factory _$$RestoredImplCopyWith(
          _$RestoredImpl value, $Res Function(_$RestoredImpl) then) =
      __$$RestoredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RestoredImplCopyWithImpl<$Res>
    extends _$SubscriptionEventCopyWithImpl<$Res, _$RestoredImpl>
    implements _$$RestoredImplCopyWith<$Res> {
  __$$RestoredImplCopyWithImpl(
      _$RestoredImpl _value, $Res Function(_$RestoredImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RestoredImpl implements _Restored {
  const _$RestoredImpl();

  @override
  String toString() {
    return 'SubscriptionEvent.restored()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RestoredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() upgraded,
    required TResult Function() cancelled,
    required TResult Function() renewed,
    required TResult Function() restored,
  }) {
    return restored();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? upgraded,
    TResult? Function()? cancelled,
    TResult? Function()? renewed,
    TResult? Function()? restored,
  }) {
    return restored?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? upgraded,
    TResult Function()? cancelled,
    TResult Function()? renewed,
    TResult Function()? restored,
    required TResult orElse(),
  }) {
    if (restored != null) {
      return restored();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Upgraded value) upgraded,
    required TResult Function(_Cancelled value) cancelled,
    required TResult Function(_Renewed value) renewed,
    required TResult Function(_Restored value) restored,
  }) {
    return restored(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Upgraded value)? upgraded,
    TResult? Function(_Cancelled value)? cancelled,
    TResult? Function(_Renewed value)? renewed,
    TResult? Function(_Restored value)? restored,
  }) {
    return restored?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Upgraded value)? upgraded,
    TResult Function(_Cancelled value)? cancelled,
    TResult Function(_Renewed value)? renewed,
    TResult Function(_Restored value)? restored,
    required TResult orElse(),
  }) {
    if (restored != null) {
      return restored(this);
    }
    return orElse();
  }
}

abstract class _Restored implements SubscriptionEvent {
  const factory _Restored() = _$RestoredImpl;
}
