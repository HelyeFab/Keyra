const admin = require('firebase-admin');
const serviceAccount = require('./service-account-key.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

function calculateReadingStreak(readDates, lastReadDate) {
  if (!lastReadDate) return 0;
  
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  
  const lastRead = new Date(lastReadDate.toDate());
  const lastReadDay = new Date(lastRead.getFullYear(), lastRead.getMonth(), lastRead.getDate());
  
  // Check if last read was today or yesterday
  if (lastReadDay.getTime() === today.getTime() || lastReadDay.getTime() === yesterday.getTime()) {
    // Count consecutive days from readDates
    let streak = 1;
    const sortedDates = readDates
      .map(timestamp => timestamp.toDate())
      .sort((a, b) => b - a); // Sort descending
    
    for (let i = 1; i < sortedDates.length; i++) {
      const currentDate = new Date(sortedDates[i-1].getFullYear(), sortedDates[i-1].getMonth(), sortedDates[i-1].getDate());
      const prevDate = new Date(sortedDates[i].getFullYear(), sortedDates[i].getMonth(), sortedDates[i].getDate());
      
      const diffDays = Math.floor((currentDate - prevDate) / (1000 * 60 * 60 * 24));
      if (diffDays === 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
  
  return 0;
}

function ensureTimestampArray(dates) {
  if (!Array.isArray(dates)) return [];
  
  return dates.map(date => {
    if (date instanceof admin.firestore.Timestamp) {
      return date;
    }
    if (date && date._seconds !== undefined && date._nanoseconds !== undefined) {
      return new admin.firestore.Timestamp(date._seconds, date._nanoseconds);
    }
    if (date instanceof Date) {
      return admin.firestore.Timestamp.fromDate(date);
    }
    if (typeof date === 'string') {
      return admin.firestore.Timestamp.fromDate(new Date(date));
    }
    return null;
  }).filter(date => date !== null);
}

async function initializeUserStats() {
  try {
    console.log('Starting user stats initialization...');

    // Get all users
    const usersSnapshot = await db.collection('users').get();
    console.log(`Found ${usersSnapshot.docs.length} users`);

    for (const userDoc of usersSnapshot.docs) {
      console.log(`\nProcessing user: ${userDoc.id}`);

      try {
        // Get saved words count
        const savedWordsSnapshot = await userDoc.ref
          .collection('saved_words')
          .get();
        const savedWordsCount = savedWordsSnapshot.docs.length;
        console.log(`Found ${savedWordsCount} saved words`);

        // Get favorites count
        const favoritesSnapshot = await userDoc.ref
          .collection('favorites')
          .get();
        const favoritesCount = favoritesSnapshot.docs.length;
        console.log(`Found ${favoritesCount} favorites`);

        // Get current stats
        const userData = userDoc.data();
        
        // Ensure readDates is properly formatted as an array of Timestamps
        const readDates = ensureTimestampArray(userData.readDates || []);
        
        // Ensure lastReadDate is a Timestamp if it exists
        const lastReadDate = userData.lastReadDate instanceof admin.firestore.Timestamp 
          ? userData.lastReadDate 
          : null;
        
        // Calculate reading streak
        const readingStreak = calculateReadingStreak(readDates, lastReadDate);
        console.log(`Calculated reading streak: ${readingStreak}`);

        // Create stats object matching UserStats model
        const stats = {
          booksRead: userData.booksRead || 0,
          favoriteBooks: favoritesCount,
          readingStreak: readingStreak,
          savedWords: savedWordsCount,
          readDates: readDates,
          isReadingActive: userData.isReadingActive || false,
          currentSessionMinutes: userData.currentSessionMinutes || 0,
          lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
        };

        // Add optional timestamp fields only if they exist
        if (userData.sessionStartTime instanceof admin.firestore.Timestamp) {
          stats.sessionStartTime = userData.sessionStartTime;
        }
        if (lastReadDate) {
          stats.lastReadDate = lastReadDate;
        }

        // Update user document with stats
        await userDoc.ref.set(stats, { merge: true });

        console.log(`Successfully updated stats for user ${userDoc.id}`);
        console.log('Stats:', JSON.stringify(stats, null, 2));
      } catch (e) {
        console.error(`Error processing user ${userDoc.id}:`, e);
      }
    }

    console.log('\nStats initialization complete!');
  } catch (e) {
    console.error('Error during stats initialization:', e);
  }

  // Exit the script
  process.exit(0);
}

initializeUserStats();
