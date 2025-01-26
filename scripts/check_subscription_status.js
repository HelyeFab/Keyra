const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function checkSubscriptionStatus() {
  const db = admin.firestore();
  
  try {
    console.log('Checking subscription status...\n');
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .where('tier', '==', 'free')
      .get();

    console.log(`Found ${subscriptionsSnapshot.size} free subscriptions\n`);
    
    for (const doc of subscriptionsSnapshot.docs) {
      const subscription = doc.data();
      const lastIncrease = subscription.lastLimitIncrease?.toDate();
      const nextIncrease = lastIncrease ? new Date(lastIncrease.getTime() + (7 * 24 * 60 * 60 * 1000)) : null;
      
      console.log(`Subscription ID: ${doc.id}`);
      console.log(`User ID: ${subscription.userId}`);
      console.log(`Books Read: ${subscription.booksRead || 0}`);
      console.log(`Book Limit: ${subscription.bookLimit || 10}`);
      console.log(`Last Limit Increase: ${lastIncrease ? lastIncrease.toLocaleString() : 'Not set'}`);
      console.log(`Next Limit Increase: ${nextIncrease ? nextIncrease.toLocaleString() : 'Not scheduled'}`);
      console.log('-------------------\n');
    }

  } catch (error) {
    console.error('Error checking subscription status:', error);
    throw error;
  }
}

// Run the check
checkSubscriptionStatus()
  .catch(error => {
    console.error('Check failed:', error);
  })
  .finally(() => {
    process.exit();
  });
