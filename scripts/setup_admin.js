const admin = require('firebase-admin');
const serviceAccount = require('../service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function setupAdmin() {
  try {
    // Create or get admin user
    let adminUser;
    try {
      adminUser = await admin.auth().getUserByEmail('admin@keyra.app');
      console.log('Admin user already exists');
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        adminUser = await admin.auth().createUser({
          email: 'admin@keyra.app',
          password: 'temporaryPassword123!', // Change this immediately after creation
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

    // Create custom token for initialization script
    const customToken = await admin.auth().createCustomToken(adminUser.uid, { admin: true });
    console.log('Custom token for initialization:', customToken);

    // Get ID token (this is what we'll use for the initialization script)
    console.log('\nNext steps:');
    console.log('1. Use this custom token to sign in and get an ID token');
    console.log('2. Use the ID token in the initialization script');
    console.log('\nCustom token:', customToken);

  } catch (error) {
    console.error('Error setting up admin:', error);
  } finally {
    process.exit();
  }
}

setupAdmin();
