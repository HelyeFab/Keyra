import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../data/services/purchase_handler.dart';
import 'purchase_event.dart';
import 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseHandler _purchaseHandler;

  PurchaseBloc({
    required PurchaseHandler purchaseHandler,
  })  : _purchaseHandler = purchaseHandler,
        super(const PurchaseState()) {
    on<PurchaseEvent>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
        productsUpdated: () => _onProductsUpdated(emit),
        purchaseCompleted: () => _onPurchaseCompleted(emit),
        purchaseFailed: (error) => _onPurchaseFailed(emit, error),
      );
    });
  }

  Future<void> _onStarted(Emitter<PurchaseState> emit) async {
    emit(state.copyWith(isLoading: true));
    await _purchaseHandler.initialize();
    
    final products = _purchaseHandler.products;
    final monthlyProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.monthlySubscriptionId,
      orElse: () => null,
    );
    final yearlyProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.yearlySubscriptionId,
      orElse: () => null,
    );
    final lifetimeProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.lifetimeSubscriptionId,
      orElse: () => null,
    );

    emit(state.copyWith(
      isLoading: false,
      isAvailable: _purchaseHandler.isAvailable,
      products: products,
      monthlyProduct: monthlyProduct,
      yearlyProduct: yearlyProduct,
      lifetimeProduct: lifetimeProduct,
    ));
  }

  Future<void> _onProductsUpdated(Emitter<PurchaseState> emit) async {
    final products = _purchaseHandler.products;
    final monthlyProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.monthlySubscriptionId,
      orElse: () => null,
    );
    final yearlyProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.yearlySubscriptionId,
      orElse: () => null,
    );
    final lifetimeProduct = products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == PurchaseHandler.lifetimeSubscriptionId,
      orElse: () => null,
    );

    emit(state.copyWith(
      products: products,
      monthlyProduct: monthlyProduct,
      yearlyProduct: yearlyProduct,
      lifetimeProduct: lifetimeProduct,
    ));
  }

  Future<void> _onPurchaseCompleted(Emitter<PurchaseState> emit) async {
    emit(state.copyWith(error: null));
  }

  Future<void> _onPurchaseFailed(Emitter<PurchaseState> emit, String error) async {
    emit(state.copyWith(error: error));
  }
}
