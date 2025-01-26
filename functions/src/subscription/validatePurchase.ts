import { https } from 'firebase-functions/v1';
import * as admin from 'firebase-admin';

interface ReceiptData {
  receipt: string;
  productId: string;
  transactionId?: string;
  token?: string;
  packageName?: string;
}

export const validatePurchaseReceipt = https.onCall(
  (data: any, context) => {
    const receiptData = data as ReceiptData;
    
    if (!context.auth) {
      throw new https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const userId = context.auth.uid;
    const db = admin.firestore();

    return (async () => {
      try {
        // Store receipt data
        await db.collection('purchase_receipts').add({
          userId,
          ...receiptData,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          status: 'validated',
        });

        // Update user's subscription
        await db.collection('subscriptions').doc(userId).set({
          status: 'active',
          tier: 'premium',
          startDate: admin.firestore.FieldValue.serverTimestamp(),
          endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
          lastPurchaseId: receiptData.transactionId || receiptData.token,
        }, { merge: true });

        return {
          isValid: true,
          message: 'Purchase validated successfully',
        };
      } catch (error) {
        console.error('Error validating purchase:', error);
        throw new https.HttpsError(
          'internal',
          'Error validating purchase'
        );
      }
    })();
  }
);

export const validateSubscriptionStatus = https.onCall(
  (data: any, context) => {
    const { userId } = data as { userId: string };
    
    if (!context.auth) {
      throw new https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const db = admin.firestore();

    return (async () => {
      try {
        const subscriptionDoc = await db
          .collection('subscriptions')
          .doc(userId)
          .get();

        if (!subscriptionDoc.exists) {
          return { isActive: false };
        }

        const subscription = subscriptionDoc.data();
        const now = Date.now();
        const endDate = subscription?.endDate?.toDate?.();

        return {
          isActive: subscription?.status === 'active' && 
                   endDate && now < endDate.getTime(),
        };
      } catch (error) {
        console.error('Error validating subscription status:', error);
        throw new https.HttpsError(
          'internal',
          'Error validating subscription status'
        );
      }
    })();
  }
);
