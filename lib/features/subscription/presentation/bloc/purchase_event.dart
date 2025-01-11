import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_event.freezed.dart';

@freezed
class PurchaseEvent with _$PurchaseEvent {
  const factory PurchaseEvent.started() = _Started;
  const factory PurchaseEvent.productsUpdated() = _ProductsUpdated;
  const factory PurchaseEvent.purchaseCompleted() = _PurchaseCompleted;
  const factory PurchaseEvent.purchaseFailed(String error) = _PurchaseFailed;
}
