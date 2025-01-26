const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function updateBookCount() {
  const db = admin.firestore();
  const userId = 'PC4DbV6nyrTtHmpcuQvDxBqEEsA2';
  
  try {
    console.log('Updating subscription for user:', userId);
    
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .where('userId', '==', userId)
      .limit(1)
      .get();

    if (subscriptionsSnapshot.empty) {
      console.log('No subscription found for user');
      return;
    }

    const doc = subscriptionsSnapshot.docs[0];
    const subscription = doc.data();

    // Update with actual books read and adjust limit
    await doc.ref.update({
      booksRead: 17,
      bookLimit: 18, // Setting to 18 to allow for current usage plus buffer
      lastLimitIncrease: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('Subscription updated successfully');
    console.log('\nUpdated values:');
    console.log('Books Read:', 17);
    console.log('Book Limit:', 18);
    console.log('Last Limit Increase:', new Date().toLocaleString());
    console.log('Next Limit Increase:', new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toLocaleString());

  } catch (error) {
    console.error('Error updating subscription:', error);
    throw error;
  }
}

// Run the update
updateBookCount()
  .catch(error => {
    console.error('Update failed:', error);
  })
  .finally(() => {
    process.exit();
  });
