import { onRequest, HttpsOptions } from 'firebase-functions/v2/https';
import { onSchedule, ScheduleOptions } from 'firebase-functions/v2/scheduler';
import { AuthUserRecord } from 'firebase-functions/v2/identity';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';
import { updateBookLimits } from './subscription/book_limit_updater';

admin.initializeApp();

interface SubscriptionData {
  id: string;
  userId: string;
  tier: 'free' | 'premium' | 'unlimited';
  status: 'active' | 'inactive' | 'expired' | 'cancelled' | 'pending';
  startDate: admin.firestore.FieldValue;
  endDate: Date;
  autoRenew: boolean;
  createdAt: admin.firestore.FieldValue;
  lastLimitIncrease: admin.firestore.FieldValue;
  bookLimit: number;
  booksRead: number;
}

const functionConfig: HttpsOptions = {
  cpu: 1,
  memory: '512MiB',
  region: 'us-central1'
};

const scheduleConfig: ScheduleOptions = {
  schedule: 'every day 00:00',
  timeZone: 'UTC',
  retryCount: 3, // Retry up to 3 times if the function fails
  maxRetrySeconds: 60, // Maximum retry period of 1 minute
};

// Schedule book limit updates to run daily at midnight
export const scheduledBookLimitUpdate = onSchedule(scheduleConfig, async (event) => {
  console.log('Starting scheduled book limit update');
  try {
    const result = await updateBookLimits();
    console.log('Completed book limit update:', result);
  } catch (error) {
    console.error('Failed to update book limits:', error);
    throw error;
  }
});

// Create a free subscription when a new user signs up
export const createUserSubscription = onRequest(functionConfig, async (req, res) => {
  const user = req.body?.user as AuthUserRecord;
  if (!user?.uid) {
    console.error('No user data provided');
    res.status(400).send('No user data provided');
    return;
  }

  const db = admin.firestore();
  
  try {
    // Check if user already has a subscription
    const existingSubscriptions = await db
      .collection('subscriptions')
      .where('userId', '==', user.uid)
      .limit(1)
      .get();

    if (!existingSubscriptions.empty) {
      console.log(`User ${user.uid} already has a subscription`);
      res.status(200).send('User already has a subscription');
      return;
    }

    // Create a new free subscription
    const subscriptionData: SubscriptionData = {
      id: uuidv4(),
      userId: user.uid,
      tier: 'free',
      status: 'active',
      startDate: admin.firestore.FieldValue.serverTimestamp(),
      endDate: new Date(Date.now() + 1000 * 60 * 60 * 24 * 365 * 100), // 100 years for free tier
      autoRenew: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp(),
      bookLimit: 10,
      booksRead: 0,
    };

    await db.collection('subscriptions').doc(subscriptionData.id).set(subscriptionData);
    console.log(`Created free subscription for user ${user.uid}`);
    res.status(200).send('Subscription created successfully');
  } catch (error) {
    console.error('Error creating subscription:', error);
    res.status(500).send('Error creating subscription');
  }
});

// One-time function to initialize lastLimitIncrease for existing subscriptions
export const initializeBookLimits = onRequest({
  ...functionConfig,
  memory: '1GiB',
  timeoutSeconds: 540, // 9 minutes
}, async (req, res) => {
  // This should be called with appropriate authentication
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) {
    res.status(401).send('Unauthorized');
    return;
  }

  try {
    // Verify the token
    const token = auth.split('Bearer ')[1];
    const decodedToken = await admin.auth().verifyIdToken(token);
    
    // Check if the user has admin claim
    if (!decodedToken.admin) {
      res.status(403).send('Forbidden: Requires admin privileges');
      return;
    }

    const db = admin.firestore();
    
    // Get all free subscriptions
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .where('tier', '==', 'free')
      .get();
    
    // Process subscriptions in batches
    const batch = db.batch();
    let updateCount = 0;
    let batchCount = 0;
    const batchArray: admin.firestore.WriteBatch[] = [batch];

    for (const doc of subscriptionsSnapshot.docs) {
      const subscription = doc.data();
      
      // Only update if lastLimitIncrease is not set
      if (!subscription.lastLimitIncrease) {
        const currentBatch = batchArray[batchArray.length - 1];
        currentBatch.update(doc.ref, {
          lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp(),
          bookLimit: subscription.bookLimit || 10,
          booksRead: subscription.booksRead || 0,
        });
        updateCount++;
        batchCount++;
      }

      // Firestore batches are limited to 500 operations
      if (batchCount === 499) {
        batchArray.push(db.batch());
        batchCount = 0;
      }
    }

    // Commit all batches
    await Promise.all(batchArray.map(batch => batch.commit()));

    res.status(200).json({
      message: 'Successfully initialized book limits',
      updatedSubscriptions: updateCount,
    });
  } catch (error) {
    console.error('Error initializing book limits:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
