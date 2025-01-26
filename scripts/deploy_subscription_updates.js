const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function initializeBookLimits() {
  const db = admin.firestore();
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
  
  try {
    console.log('Getting free subscriptions...');
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .where('tier', '==', 'free')
      .get();

    console.log(`Found ${subscriptionsSnapshot.size} free subscriptions`);
    
    // Process subscriptions in batches
    const batch = db.batch();
    let updateCount = 0;
    let batchCount = 0;
    const batchArray = [batch];

    for (const doc of subscriptionsSnapshot.docs) {
      const subscription = doc.data();
      
      // Initialize lastLimitIncrease if not set
      if (!subscription.lastLimitIncrease) {
        const currentBatch = batchArray[batchArray.length - 1];
        currentBatch.update(doc.ref, {
          lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp(),
          bookLimit: subscription.bookLimit || 10,
          booksRead: subscription.booksRead || 0,
        });
        updateCount++;
        batchCount++;
        
        console.log(`Initializing subscription ${doc.id} for user ${subscription.userId}`);
      }

      // Firestore batches are limited to 500 operations
      if (batchCount === 499) {
        batchArray.push(db.batch());
        batchCount = 0;
      }
    }

    // Commit all batches
    if (updateCount > 0) {
      console.log(`Committing updates for ${updateCount} subscriptions...`);
      await Promise.all(batchArray.map(batch => batch.commit()));
      console.log('Updates committed successfully');
    } else {
      console.log('No subscriptions needed initialization');
    }

    return { updatedSubscriptions: updateCount };
  } catch (error) {
    console.error('Error initializing book limits:', error);
    throw error;
  }
}

// Run the initialization
initializeBookLimits()
  .then(result => {
    console.log('\nInitialization complete!');
    console.log(`Updated ${result.updatedSubscriptions} subscriptions`);
    console.log('\nNext steps:');
    console.log('1. The scheduled function will run daily at midnight UTC');
    console.log('2. Book limits will increase automatically for eligible users');
    console.log('3. Monitor the Cloud Functions logs for any issues');
  })
  .catch(error => {
    console.error('Initialization failed:', error);
  })
  .finally(() => {
    process.exit();
  });
