const admin = require('firebase-admin');
const serviceAccount = require('../service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function updateSubscriptionTier(subscriptionId, newTier) {
  try {
    const db = admin.firestore();
    
    // Update the subscription
    await db.collection('subscriptions').doc(subscriptionId).update({
      tier: newTier,
      // Update timestamp to track when the tier was changed
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log(`Successfully updated subscription ${subscriptionId} to ${newTier} tier`);
    
    // Fetch and display the updated subscription
    const subscription = await db.collection('subscriptions').doc(subscriptionId).get();
    console.log('\nUpdated subscription:', subscription.data());

  } catch (error) {
    console.error('Error updating subscription:', error);
  } finally {
    process.exit();
  }
}

// Get subscription ID and new tier from command line arguments
const subscriptionId = process.argv[2];
const newTier = process.argv[3];

if (!subscriptionId || !newTier) {
  console.error('Please provide subscription ID and new tier');
  console.log('Usage: node update_subscription.js <subscription-id> <new-tier>');
  console.log('Example: node update_subscription.js 4b2cfb6d-7d78-412a-a95f-32d6738a95f5 premium');
  process.exit(1);
}

// Validate tier
const validTiers = ['free', 'premium', 'unlimited'];
if (!validTiers.includes(newTier)) {
  console.error('Invalid tier. Must be one of:', validTiers.join(', '));
  process.exit(1);
}

updateSubscriptionTier(subscriptionId, newTier);
