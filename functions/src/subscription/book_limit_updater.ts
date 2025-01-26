import * as admin from 'firebase-admin';

export async function updateBookLimits() {
  const db = admin.firestore();
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
  
  try {
    // Get all free tier subscriptions
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .where('tier', '==', 'free')
      .where('status', '==', 'active')
      .get();

    console.log(`Checking ${subscriptionsSnapshot.size} free subscriptions`);
    
    // Process subscriptions in batches
    const batch = db.batch();
    let updateCount = 0;

    for (const doc of subscriptionsSnapshot.docs) {
      const subscription = doc.data();
      const lastIncrease = subscription.lastLimitIncrease?.toDate();
      
      // Update if last increase was more than 7 days ago
      if (lastIncrease && lastIncrease < sevenDaysAgo) {
        batch.update(doc.ref, {
          bookLimit: subscription.bookLimit + 1,
          lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp(),
        });
        updateCount++;
        console.log(`Increasing book limit for user ${subscription.userId} from ${subscription.bookLimit} to ${subscription.bookLimit + 1}`);
      }
    }

    // Commit the batch if there are updates
    if (updateCount > 0) {
      await batch.commit();
      console.log(`Updated book limits for ${updateCount} subscriptions`);
    } else {
      console.log('No subscriptions needed updating');
    }

    return { updatedSubscriptions: updateCount };
  } catch (error) {
    console.error('Error updating book limits:', error);
    throw error;
  }
}
