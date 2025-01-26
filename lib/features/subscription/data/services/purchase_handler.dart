import 'dart:async';
import 'package:Keyra/core/utils/logger.dart';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'receipt_validator.dart';

class PurchaseHandler {
  static const String _monthlySubscriptionId = 'keyra_premium_monthly';
  static const String _yearlySubscriptionId = 'keyra_premium_yearly';
  static const String _lifetimeSubscriptionId = 'keyra_premium_lifetime';

  final InAppPurchase _inAppPurchase;
  final ReceiptValidator _receiptValidator;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  // Callbacks for purchase status
  final void Function(String message)? onError;
  final void Function()? onPending;
  final void Function(PurchaseDetails)? onPurchaseVerified;

  PurchaseHandler({
    InAppPurchase? inAppPurchase,
    ReceiptValidator? receiptValidator,
    this.onError,
    this.onPending,
    this.onPurchaseVerified,
  })  : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance,
        _receiptValidator = receiptValidator ?? ReceiptValidator();

  Future<void> initialize() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        onError?.call('Store is not available');
        return;
      }

      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _inAppPurchase
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      final Set<String> identifiers = {
        _monthlySubscriptionId,
        _yearlySubscriptionId,
        _lifetimeSubscriptionId,
      };

      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(identifiers);

      if (response.notFoundIDs.isNotEmpty) {
        Logger.log('Products not found: ${response.notFoundIDs}');
        if (response.notFoundIDs.length == identifiers.length) {
          _isAvailable = false;
          onError?.call('No products available for purchase');
          return;
        }
      }

      if (response.error != null) {
        Logger.error('Error loading products', error: response.error);
        _isAvailable = false;
        onError?.call('Error loading products: ${response.error}');
        return;
      }

      _products = response.productDetails;
      Logger.log('Loaded ${_products.length} products');
      for (var product in _products) {
        Logger.log('Product: ${product.id} - ${product.price}');
      }

      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdate,
        onDone: _updateStreamOnDone,
        onError: _updateStreamOnError,
      );
    } catch (e) {
      Logger.error('Failed to initialize purchases', error: e);
      _isAvailable = false;
      onError?.call('Failed to initialize store: $e');
    }
  }

  Future<void> buySubscription(String subscriptionId) async {
    if (!_isAvailable) {
      onError?.call('Store is not available');
      return;
    }

    final ProductDetails? product = _products.isEmpty
        ? null
        : _products.firstWhere(
            (product) => product.id == subscriptionId,
            orElse: () => _products.first,
          );

    if (product == null) {
      onError?.call('Product not found');
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
      applicationUserName: null,
    );

    try {
      if (Platform.isAndroid) {
        // On Android, the subscription parameter must be true for subscription products
        final bool isSubscription = subscriptionId != _lifetimeSubscriptionId;
        if (isSubscription) {
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        } else {
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        }
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      onError?.call('Failed to make purchase: ${e.toString()}');
    }
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        onPending?.call();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          onError?.call(purchaseDetails.error?.message ?? 'Purchase failed');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Validate the purchase with Firebase Functions
          final isValid =
              await _receiptValidator.validatePurchase(purchaseDetails);
          if (isValid) {
            onPurchaseVerified?.call(purchaseDetails);
          } else {
            onError?.call('Purchase validation failed');
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _updateStreamOnDone() {
    _subscription?.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    onError?.call('Error in purchase stream: $error');
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      onError?.call('Failed to restore purchases: ${e.toString()}');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }

  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;

  static String get monthlySubscriptionId => _monthlySubscriptionId;
  static String get yearlySubscriptionId => _yearlySubscriptionId;
  static String get lifetimeSubscriptionId => _lifetimeSubscriptionId;
}

class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
