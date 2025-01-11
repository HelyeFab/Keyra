import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'purchase_state.freezed.dart';

@freezed
class PurchaseState with _$PurchaseState {
  const factory PurchaseState({
    @Default(false) bool isAvailable,
    @Default([]) List<ProductDetails> products,
    ProductDetails? monthlyProduct,
    ProductDetails? yearlyProduct,
    ProductDetails? lifetimeProduct,
    @Default(false) bool isLoading,
    String? error,
  }) = _PurchaseState;
}
