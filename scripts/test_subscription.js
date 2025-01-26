const fetch = require('node-fetch');

async function getIdToken(customToken) {
  if (!customToken) {
    console.error('Please provide a custom token as an argument');
    console.log('Usage: node test_subscription.js <custom-token>');
    process.exit(1);
  }

  const apiKey = process.env.FIREBASE_API_KEY || process.env.FIREBASE_WEBAPP_API_KEY;
  if (!apiKey) {
    console.error('Error: FIREBASE_API_KEY or FIREBASE_WEBAPP_API_KEY environment variable is required');
    process.exit(1);
  }

  console.log('Using API Key:', apiKey);

  try {
    // Exchange custom token for ID token
    console.log('Exchanging custom token for ID token...');
    const response = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${apiKey}`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          token: customToken,
          returnSecureToken: true,
        }),
      }
    );

    const data = await response.json();
    if (data.error) {
      throw new Error(data.error.message);
    }

    console.log('\nID Token obtained successfully. Use this token to test the functions:');
    console.log(data.idToken);

    // Test initializeExistingUsersSubscriptions function
    console.log('\nTesting initializeExistingUsersSubscriptions function...');
    const initResponse = await fetch(
      'https://us-central1-keyra-93667.cloudfunctions.net/initializeExistingUsersSubscriptions',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${data.idToken}`,
        },
      }
    );

    const initData = await initResponse.json();
    console.log('\nResponse:', initData);

  } catch (error) {
    console.error('Error:', error.message);
  }
}

// Get custom token from command line argument
const customToken = process.argv[2];
getIdToken(customToken);
