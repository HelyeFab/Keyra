// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PurchaseEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() productsUpdated,
    required TResult Function() purchaseCompleted,
    required TResult Function(String error) purchaseFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? productsUpdated,
    TResult? Function()? purchaseCompleted,
    TResult? Function(String error)? purchaseFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? productsUpdated,
    TResult Function()? purchaseCompleted,
    TResult Function(String error)? purchaseFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ProductsUpdated value) productsUpdated,
    required TResult Function(_PurchaseCompleted value) purchaseCompleted,
    required TResult Function(_PurchaseFailed value) purchaseFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ProductsUpdated value)? productsUpdated,
    TResult? Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult? Function(_PurchaseFailed value)? purchaseFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ProductsUpdated value)? productsUpdated,
    TResult Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult Function(_PurchaseFailed value)? purchaseFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseEventCopyWith<$Res> {
  factory $PurchaseEventCopyWith(
          PurchaseEvent value, $Res Function(PurchaseEvent) then) =
      _$PurchaseEventCopyWithImpl<$Res, PurchaseEvent>;
}

/// @nodoc
class _$PurchaseEventCopyWithImpl<$Res, $Val extends PurchaseEvent>
    implements $PurchaseEventCopyWith<$Res> {
  _$PurchaseEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseEvent
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
    extends _$PurchaseEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'PurchaseEvent.started()';
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
    required TResult Function() productsUpdated,
    required TResult Function() purchaseCompleted,
    required TResult Function(String error) purchaseFailed,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? productsUpdated,
    TResult? Function()? purchaseCompleted,
    TResult? Function(String error)? purchaseFailed,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? productsUpdated,
    TResult Function()? purchaseCompleted,
    TResult Function(String error)? purchaseFailed,
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
    required TResult Function(_ProductsUpdated value) productsUpdated,
    required TResult Function(_PurchaseCompleted value) purchaseCompleted,
    required TResult Function(_PurchaseFailed value) purchaseFailed,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ProductsUpdated value)? productsUpdated,
    TResult? Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult? Function(_PurchaseFailed value)? purchaseFailed,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ProductsUpdated value)? productsUpdated,
    TResult Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult Function(_PurchaseFailed value)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements PurchaseEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$ProductsUpdatedImplCopyWith<$Res> {
  factory _$$ProductsUpdatedImplCopyWith(_$ProductsUpdatedImpl value,
          $Res Function(_$ProductsUpdatedImpl) then) =
      __$$ProductsUpdatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsUpdatedImplCopyWithImpl<$Res>
    extends _$PurchaseEventCopyWithImpl<$Res, _$ProductsUpdatedImpl>
    implements _$$ProductsUpdatedImplCopyWith<$Res> {
  __$$ProductsUpdatedImplCopyWithImpl(
      _$ProductsUpdatedImpl _value, $Res Function(_$ProductsUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsUpdatedImpl implements _ProductsUpdated {
  const _$ProductsUpdatedImpl();

  @override
  String toString() {
    return 'PurchaseEvent.productsUpdated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsUpdatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() productsUpdated,
    required TResult Function() purchaseCompleted,
    required TResult Function(String error) purchaseFailed,
  }) {
    return productsUpdated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? productsUpdated,
    TResult? Function()? purchaseCompleted,
    TResult? Function(String error)? purchaseFailed,
  }) {
    return productsUpdated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? productsUpdated,
    TResult Function()? purchaseCompleted,
    TResult Function(String error)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (productsUpdated != null) {
      return productsUpdated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ProductsUpdated value) productsUpdated,
    required TResult Function(_PurchaseCompleted value) purchaseCompleted,
    required TResult Function(_PurchaseFailed value) purchaseFailed,
  }) {
    return productsUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ProductsUpdated value)? productsUpdated,
    TResult? Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult? Function(_PurchaseFailed value)? purchaseFailed,
  }) {
    return productsUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ProductsUpdated value)? productsUpdated,
    TResult Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult Function(_PurchaseFailed value)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (productsUpdated != null) {
      return productsUpdated(this);
    }
    return orElse();
  }
}

abstract class _ProductsUpdated implements PurchaseEvent {
  const factory _ProductsUpdated() = _$ProductsUpdatedImpl;
}

/// @nodoc
abstract class _$$PurchaseCompletedImplCopyWith<$Res> {
  factory _$$PurchaseCompletedImplCopyWith(_$PurchaseCompletedImpl value,
          $Res Function(_$PurchaseCompletedImpl) then) =
      __$$PurchaseCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PurchaseCompletedImplCopyWithImpl<$Res>
    extends _$PurchaseEventCopyWithImpl<$Res, _$PurchaseCompletedImpl>
    implements _$$PurchaseCompletedImplCopyWith<$Res> {
  __$$PurchaseCompletedImplCopyWithImpl(_$PurchaseCompletedImpl _value,
      $Res Function(_$PurchaseCompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PurchaseCompletedImpl implements _PurchaseCompleted {
  const _$PurchaseCompletedImpl();

  @override
  String toString() {
    return 'PurchaseEvent.purchaseCompleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PurchaseCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() productsUpdated,
    required TResult Function() purchaseCompleted,
    required TResult Function(String error) purchaseFailed,
  }) {
    return purchaseCompleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? productsUpdated,
    TResult? Function()? purchaseCompleted,
    TResult? Function(String error)? purchaseFailed,
  }) {
    return purchaseCompleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? productsUpdated,
    TResult Function()? purchaseCompleted,
    TResult Function(String error)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (purchaseCompleted != null) {
      return purchaseCompleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ProductsUpdated value) productsUpdated,
    required TResult Function(_PurchaseCompleted value) purchaseCompleted,
    required TResult Function(_PurchaseFailed value) purchaseFailed,
  }) {
    return purchaseCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ProductsUpdated value)? productsUpdated,
    TResult? Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult? Function(_PurchaseFailed value)? purchaseFailed,
  }) {
    return purchaseCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ProductsUpdated value)? productsUpdated,
    TResult Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult Function(_PurchaseFailed value)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (purchaseCompleted != null) {
      return purchaseCompleted(this);
    }
    return orElse();
  }
}

abstract class _PurchaseCompleted implements PurchaseEvent {
  const factory _PurchaseCompleted() = _$PurchaseCompletedImpl;
}

/// @nodoc
abstract class _$$PurchaseFailedImplCopyWith<$Res> {
  factory _$$PurchaseFailedImplCopyWith(_$PurchaseFailedImpl value,
          $Res Function(_$PurchaseFailedImpl) then) =
      __$$PurchaseFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$PurchaseFailedImplCopyWithImpl<$Res>
    extends _$PurchaseEventCopyWithImpl<$Res, _$PurchaseFailedImpl>
    implements _$$PurchaseFailedImplCopyWith<$Res> {
  __$$PurchaseFailedImplCopyWithImpl(
      _$PurchaseFailedImpl _value, $Res Function(_$PurchaseFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$PurchaseFailedImpl(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PurchaseFailedImpl implements _PurchaseFailed {
  const _$PurchaseFailedImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'PurchaseEvent.purchaseFailed(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseFailedImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseFailedImplCopyWith<_$PurchaseFailedImpl> get copyWith =>
      __$$PurchaseFailedImplCopyWithImpl<_$PurchaseFailedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() productsUpdated,
    required TResult Function() purchaseCompleted,
    required TResult Function(String error) purchaseFailed,
  }) {
    return purchaseFailed(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? productsUpdated,
    TResult? Function()? purchaseCompleted,
    TResult? Function(String error)? purchaseFailed,
  }) {
    return purchaseFailed?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? productsUpdated,
    TResult Function()? purchaseCompleted,
    TResult Function(String error)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (purchaseFailed != null) {
      return purchaseFailed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ProductsUpdated value) productsUpdated,
    required TResult Function(_PurchaseCompleted value) purchaseCompleted,
    required TResult Function(_PurchaseFailed value) purchaseFailed,
  }) {
    return purchaseFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ProductsUpdated value)? productsUpdated,
    TResult? Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult? Function(_PurchaseFailed value)? purchaseFailed,
  }) {
    return purchaseFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ProductsUpdated value)? productsUpdated,
    TResult Function(_PurchaseCompleted value)? purchaseCompleted,
    TResult Function(_PurchaseFailed value)? purchaseFailed,
    required TResult orElse(),
  }) {
    if (purchaseFailed != null) {
      return purchaseFailed(this);
    }
    return orElse();
  }
}

abstract class _PurchaseFailed implements PurchaseEvent {
  const factory _PurchaseFailed(final String error) = _$PurchaseFailedImpl;

  String get error;

  /// Create a copy of PurchaseEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseFailedImplCopyWith<_$PurchaseFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
