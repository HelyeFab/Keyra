const admin = require('firebase-admin');
const serviceAccount = require('../service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function initializeSubscriptions() {
  try {
    // Create an admin user if it doesn't exist
    let adminUser;
    try {
      adminUser = await admin.auth().getUserByEmail('admin@keyra.app');
      console.log('Admin user already exists');
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        adminUser = await admin.auth().createUser({
          email: 'admin@keyra.app',
          password: process.env.ADMIN_PASSWORD || 'temporaryPassword123!',
          emailVerified: true,
        });
        console.log('Created new admin user');
      } else {
        throw error;
      }
    }

    // Set admin claim
    await admin.auth().setCustomUserClaims(adminUser.uid, { admin: true });
    console.log('Set admin claim for user');

    // Create Firestore indexes
    const db = admin.firestore();
    
    // Create compound index for subscriptions
    await db.collection('subscriptions').doc('__indexes__').set({
      'userId_createdAt': {
        fields: [
          { fieldPath: 'userId', order: 'ASCENDING' },
          { fieldPath: 'createdAt', order: 'DESCENDING' }
        ]
      }
    });

    console.log('Successfully initialized subscription system');
    console.log('Admin user email: admin@keyra.app');
    
    // Get ID token for testing
    const customToken = await admin.auth().createCustomToken(adminUser.uid, { admin: true });
    console.log('\nCustom token for testing:');
    console.log(customToken);
    
    console.log('\nNext steps:');
    console.log('1. Use this token with the Firebase Auth REST API to get an ID token');
    console.log('2. Use the ID token to call the initializeExistingUsersSubscriptions function');
    console.log(`3. Function URL: https://us-central1-keyra-93667.cloudfunctions.net/initializeExistingUsersSubscriptions`);

  } catch (error) {
    console.error('Error initializing subscriptions:', error);
  } finally {
    process.exit();
  }
}

// Check if service account exists
try {
  require('../service-account-key.json');
  initializeSubscriptions();
} catch (error) {
  console.error('\nError: service-account-key.json not found');
  console.log('\nPlease follow these steps:');
  console.log('1. Go to Firebase Console > Project Settings > Service Accounts');
  console.log('2. Click "Generate New Private Key"');
  console.log('3. Save the file as "service-account-key.json" in the project root');
  console.log('4. Run this script again');
  process.exit(1);
}
