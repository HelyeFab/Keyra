const { initializeApp } = require('firebase/app');
const { getAuth, signInWithCustomToken } = require('firebase/auth');

// Your web app's Firebase configuration
const firebaseConfig = {
  projectId: "keyra-93667",
  apiKey: process.env.FIREBASE_API_KEY, // Set this in your environment
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

async function getIdToken(customToken) {
  try {
    if (!process.env.FIREBASE_API_KEY) {
      throw new Error('FIREBASE_API_KEY environment variable is required');
    }

    if (!customToken) {
      throw new Error('Custom token is required. Pass it as an argument: node get_id_token.js <custom-token>');
    }

    const userCredential = await signInWithCustomToken(auth, customToken);
    const idToken = await userCredential.user.getIdToken();
    
    console.log('\nID Token (use this for initialization):', idToken);
    
  } catch (error) {
    console.error('Error getting ID token:', error);
  } finally {
    process.exit();
  }
}

// Get custom token from command line argument
const customToken = process.argv[2];
getIdToken(customToken);
