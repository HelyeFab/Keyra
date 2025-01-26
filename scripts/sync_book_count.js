const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin with admin privileges
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseAuthVariableOverride: {
    uid: 'server-admin',
    admin: true
  }
});

async function syncBookCount() {
  const db = admin.firestore();
  const userId = 'PC4DbV6nyrTtHmpcuQvDxBqEEsA2';
  const mainSubscriptionId = '264fd8cb-2b0b-405f-b01c-9a56fe09e4ce';
  
  try {
    console.log('Syncing book count with app data');
    
    // Update the subscription with actual book count
    const subscriptionRef = db.collection('subscriptions').doc(mainSubscriptionId);
    await subscriptionRef.update({
      booksRead: 22,
      bookLimit: 23, // Setting to 23 to allow for current usage plus buffer
      lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp()
    });

    // Verify the update
    const updatedDoc = await subscriptionRef.get();
    const data = updatedDoc.data();
    
    console.log('\nSubscription updated:');
    console.log('Books Read:', data.booksRead);
    console.log('Book Limit:', data.bookLimit);
    console.log('Last Limit Increase:', data.lastLimitIncrease.toDate().toLocaleString());
    console.log('Next Limit Increase:', new Date(data.lastLimitIncrease.toDate().getTime() + 7 * 24 * 60 * 60 * 1000).toLocaleString());

  } catch (error) {
    console.error('Error syncing book count:', error);
    throw error;
  }
}

// Run the sync
syncBookCount()
  .catch(error => {
    console.error('Sync failed:', error);
  })
  .finally(() => {
    process.exit();
  });
