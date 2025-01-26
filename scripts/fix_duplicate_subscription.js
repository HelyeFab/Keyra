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

async function fixDuplicateSubscription() {
  const db = admin.firestore();
  const userId = 'PC4DbV6nyrTtHmpcuQvDxBqEEsA2';
  
  try {
    console.log('Finding subscriptions for user:', userId);
    
    // Get all subscriptions for the user
    const subscriptionsSnapshot = await db
      .collection('subscriptions')
      .get();

    console.log(`Found ${subscriptionsSnapshot.size} total subscriptions`);

    // Filter subscriptions for our user
    const userSubscriptions = subscriptionsSnapshot.docs
      .filter(doc => doc.data().userId === userId || doc.id === userId)
      .map(doc => ({
        id: doc.id,
        ...doc.data()
      }));

    console.log(`Found ${userSubscriptions.length} subscriptions for user`);

    if (userSubscriptions.length === 0) {
      console.log('No subscriptions found for user');
      return;
    }

    // Find the subscription with the highest book count
    const mainSubscription = userSubscriptions.reduce((prev, current) => 
      (prev.booksRead > current.booksRead) ? prev : current
    );

    console.log('\nMain subscription:', mainSubscription.id);
    console.log('Books Read:', mainSubscription.booksRead);
    console.log('Book Limit:', mainSubscription.bookLimit);

    // Delete duplicates one by one
    for (const subscription of userSubscriptions) {
      if (subscription.id !== mainSubscription.id) {
        console.log(`\nDeleting duplicate subscription: ${subscription.id}`);
        try {
          await db.collection('subscriptions').doc(subscription.id).delete();
          console.log('Successfully deleted');
        } catch (e) {
          console.error(`Error deleting ${subscription.id}:`, e);
        }
      }
    }

    console.log('\nCleanup completed');

  } catch (error) {
    console.error('Error fixing duplicate subscription:', error);
    throw error;
  }
}

// Run the fix
fixDuplicateSubscription()
  .catch(error => {
    console.error('Fix failed:', error);
  })
  .finally(() => {
    process.exit();
  });
