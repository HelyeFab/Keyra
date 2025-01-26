import 'dart:io';
import 'package:Keyra/core/utils/logger.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ReceiptValidator {
  final FirebaseFunctions _functions;

  ReceiptValidator({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  Future<bool> validatePurchase(PurchaseDetails purchase) async {
    try {
      // Get the appropriate receipt data based on platform
      final Map<String, dynamic> receiptData = Platform.isIOS
          ? {
              'receipt': purchase.verificationData.serverVerificationData,
              'productId': purchase.productID,
              'transactionId': purchase.purchaseID,
            }
          : {
              'receipt': purchase.verificationData.serverVerificationData,
              'productId': purchase.productID,
              'token': purchase.verificationData.localVerificationData,
              'packageName': Platform.isAndroid ? 'com.keyra.app' : null,
            };

      // Call Firebase Function to validate receipt
      final result = await _functions
          .httpsCallable('validatePurchaseReceipt')
          .call(receiptData);

      final bool isValid = result.data['isValid'] as bool;
      if (!isValid) {
        Logger.error('Receipt validation failed', error: result.data['message']);
      }
      return isValid;
    } catch (e) {
      Logger.error('Failed to validate receipt', error: e);
      return false;
    }
  }

  Future<bool> validateSubscriptionStatus(String userId) async {
    try {
      final result = await _functions
          .httpsCallable('validateSubscriptionStatus')
          .call({'userId': userId});

      return result.data['isActive'] as bool;
    } catch (e) {
      Logger.error('Failed to validate subscription status', error: e);
      return false;
    }
  }
}
