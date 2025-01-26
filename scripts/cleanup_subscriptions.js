const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function cleanupSubscriptions() {
  const db = admin.firestore();
  console.log('Starting subscription cleanup');

  try {
    // Get all subscriptions
    const subscriptionsSnapshot = await db.collection('subscriptions').get();
    const subscriptions = [];
    
    // Group subscriptions by userId
    const userSubscriptions = {};
    
    subscriptionsSnapshot.forEach(doc => {
      const data = doc.data();
      if (!userSubscriptions[data.userId]) {
        userSubscriptions[data.userId] = [];
      }
      userSubscriptions[data.userId].push({
        id: doc.id,
        ...data
      });
    });

    // For each user with multiple subscriptions
    for (const [userId, subs] of Object.entries(userSubscriptions)) {
      if (subs.length > 1) {
        console.log(`Found ${subs.length} subscriptions for user ${userId}`);
        
        // Sort by booksRead (descending) to keep the one with most books
        subs.sort((a, b) => (b.booksRead || 0) - (a.booksRead || 0));
        
        // Keep the subscription with the highest book count
        const mainSubscription = subs[0];
        console.log('\nMain subscription verified:');
        console.log('ID:', mainSubscription.id);
        console.log('Books Read:', mainSubscription.booksRead);
        console.log('Book Limit:', mainSubscription.bookLimit);
        console.log('User ID:', mainSubscription.userId);
        
        // Delete other subscriptions
        for (let i = 1; i < subs.length; i++) {
          console.log(`Deleting duplicate subscription: ${subs[i].id}`);
          await db.collection('subscriptions').doc(subs[i].id).delete();
        }
        
        // Update the main subscription to use userId as document ID if it's not already
        if (mainSubscription.id !== userId) {
          console.log(`Moving main subscription to use userId as document ID`);
          await db.collection('subscriptions').doc(userId).set(mainSubscription);
          await db.collection('subscriptions').doc(mainSubscription.id).delete();
        }
      }
    }

    console.log('\nSuccessfully deleted duplicate subscription');
  } catch (error) {
    console.error('Error cleaning up subscriptions:', error);
  }
}

// Run the cleanup
cleanupSubscriptions()
  .catch(console.error)
  .finally(() => process.exit());
