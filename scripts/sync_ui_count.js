const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function syncUICount() {
  const db = admin.firestore();
  const userId = 'PC4DbV6nyrTtHmpcuQvDxBqEEsA2';
  
  try {
    console.log('Syncing book count with UI data');
    
    // Get the user's stats first (source of truth)
    const statsDoc = await db
      .collection('users')
      .doc(userId)
      .collection('stats')
      .doc('current')
      .get();
    
    if (!statsDoc.exists) {
      throw new Error('Stats document not found');
    }

    const statsData = statsDoc.data();
    const booksRead = statsData.booksRead || 0;
    console.log('\nStats data:');
    console.log('Books Read:', booksRead);
    
    // Update the subscription with actual book count
    const subscriptionRef = db.collection('subscriptions').doc(userId);
    await subscriptionRef.update({
      booksRead: booksRead,
      bookLimit: booksRead + 1, // Setting to booksRead + 1 to allow for current usage plus buffer
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
syncUICount()
  .catch(error => {
    console.error('Sync failed:', error);
  })
  .finally(() => {
    process.exit();
  });
