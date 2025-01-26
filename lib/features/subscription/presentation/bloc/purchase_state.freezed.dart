// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PurchaseState {
  bool get isAvailable => throw _privateConstructorUsedError;
  List<ProductDetails> get products => throw _privateConstructorUsedError;
  ProductDetails? get monthlyProduct => throw _privateConstructorUsedError;
  ProductDetails? get yearlyProduct => throw _privateConstructorUsedError;
  ProductDetails? get lifetimeProduct => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseStateCopyWith<PurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateCopyWith(
          PurchaseState value, $Res Function(PurchaseState) then) =
      _$PurchaseStateCopyWithImpl<$Res, PurchaseState>;
  @useResult
  $Res call(
      {bool isAvailable,
      List<ProductDetails> products,
      ProductDetails? monthlyProduct,
      ProductDetails? yearlyProduct,
      ProductDetails? lifetimeProduct,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$PurchaseStateCopyWithImpl<$Res, $Val extends PurchaseState>
    implements $PurchaseStateCopyWith<$Res> {
  _$PurchaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAvailable = null,
    Object? products = null,
    Object? monthlyProduct = freezed,
    Object? yearlyProduct = freezed,
    Object? lifetimeProduct = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductDetails>,
      monthlyProduct: freezed == monthlyProduct
          ? _value.monthlyProduct
          : monthlyProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      yearlyProduct: freezed == yearlyProduct
          ? _value.yearlyProduct
          : yearlyProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      lifetimeProduct: freezed == lifetimeProduct
          ? _value.lifetimeProduct
          : lifetimeProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseStateImplCopyWith<$Res>
    implements $PurchaseStateCopyWith<$Res> {
  factory _$$PurchaseStateImplCopyWith(
          _$PurchaseStateImpl value, $Res Function(_$PurchaseStateImpl) then) =
      __$$PurchaseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isAvailable,
      List<ProductDetails> products,
      ProductDetails? monthlyProduct,
      ProductDetails? yearlyProduct,
      ProductDetails? lifetimeProduct,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$PurchaseStateImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateImpl>
    implements _$$PurchaseStateImplCopyWith<$Res> {
  __$$PurchaseStateImplCopyWithImpl(
      _$PurchaseStateImpl _value, $Res Function(_$PurchaseStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAvailable = null,
    Object? products = null,
    Object? monthlyProduct = freezed,
    Object? yearlyProduct = freezed,
    Object? lifetimeProduct = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$PurchaseStateImpl(
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductDetails>,
      monthlyProduct: freezed == monthlyProduct
          ? _value.monthlyProduct
          : monthlyProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      yearlyProduct: freezed == yearlyProduct
          ? _value.yearlyProduct
          : yearlyProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      lifetimeProduct: freezed == lifetimeProduct
          ? _value.lifetimeProduct
          : lifetimeProduct // ignore: cast_nullable_to_non_nullable
              as ProductDetails?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PurchaseStateImpl implements _PurchaseState {
  const _$PurchaseStateImpl(
      {this.isAvailable = false,
      final List<ProductDetails> products = const [],
      this.monthlyProduct,
      this.yearlyProduct,
      this.lifetimeProduct,
      this.isLoading = false,
      this.error})
      : _products = products;

  @override
  @JsonKey()
  final bool isAvailable;
  final List<ProductDetails> _products;
  @override
  @JsonKey()
  List<ProductDetails> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final ProductDetails? monthlyProduct;
  @override
  final ProductDetails? yearlyProduct;
  @override
  final ProductDetails? lifetimeProduct;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'PurchaseState(isAvailable: $isAvailable, products: $products, monthlyProduct: $monthlyProduct, yearlyProduct: $yearlyProduct, lifetimeProduct: $lifetimeProduct, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateImpl &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.monthlyProduct, monthlyProduct) ||
                other.monthlyProduct == monthlyProduct) &&
            (identical(other.yearlyProduct, yearlyProduct) ||
                other.yearlyProduct == yearlyProduct) &&
            (identical(other.lifetimeProduct, lifetimeProduct) ||
                other.lifetimeProduct == lifetimeProduct) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isAvailable,
      const DeepCollectionEquality().hash(_products),
      monthlyProduct,
      yearlyProduct,
      lifetimeProduct,
      isLoading,
      error);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStateImplCopyWith<_$PurchaseStateImpl> get copyWith =>
      __$$PurchaseStateImplCopyWithImpl<_$PurchaseStateImpl>(this, _$identity);
}

abstract class _PurchaseState implements PurchaseState {
  const factory _PurchaseState(
      {final bool isAvailable,
      final List<ProductDetails> products,
      final ProductDetails? monthlyProduct,
      final ProductDetails? yearlyProduct,
      final ProductDetails? lifetimeProduct,
      final bool isLoading,
      final String? error}) = _$PurchaseStateImpl;

  @override
  bool get isAvailable;
  @override
  List<ProductDetails> get products;
  @override
  ProductDetails? get monthlyProduct;
  @override
  ProductDetails? get yearlyProduct;
  @override
  ProductDetails? get lifetimeProduct;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStateImplCopyWith<_$PurchaseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
