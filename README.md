# Keyra - Interactive Multilingual Children's Book App

A Flutter application that provides an interactive reading experience with AI-generated stories available in multiple languages.

## Features

- Books available in multiple languages (English, French, Spanish, Italian, German, Japanese)
- Interactive reading experience with images and text
- Audio narration in all supported languages
- AI-generated content (stories, images, and audio)
- Favorite books functionality
- Search and filter capabilities
- User profiles and reading progress tracking
- Word lookup with dictionary support for all languages

## Subscription Tiers

The app offers two subscription tiers to provide flexibility for different user needs:

### Free Tier
- Access to a limited number of books (starts with 10)
- Book limit increases by 1 every 7 days automatically
- Basic reading features
- Access to basic dictionary features
- Book limit progress tracking

### Premium Tier
- Unlimited book access
- Advanced study features including:
  - Flashcard study sessions
  - Progress tracking
  - Personalized learning paths
- Full dictionary and translation features
- Priority access to new content

## Book Limit System

The app implements a progressive book limit system for free users:

- Initial limit: 10 books
- Automatic increase: +1 book every 7 days
- Progress tracking:
  - Current books read
  - Current book limit
  - Next limit increase date
- Limit increase persistence:
  - Tracked in Firestore
  - Automatically checked daily
  - Updates synchronized across devices

### Deploying the Book Limit System

1. Deploy the Cloud Functions:
```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

2. Deploy the Firestore Rules:
```bash
firebase deploy --only firestore:rules
```

3. Initialize existing subscriptions:
```bash
cd scripts
npm install
node deploy_subscription_updates.js
To update book limits, run:
cd scripts && node fix_book_count.js && node check_subscription_status.js
```

4. Monitor the deployment:
- Check the Firebase Console > Functions for the scheduled function
- Monitor function logs for any issues
- Verify subscription updates in Firestore

### Book Limit System Architecture

The system consists of several components:

1. Cloud Functions:
   - `scheduledBookLimitUpdate`: Runs daily at midnight UTC
   - `initializeBookLimits`: One-time setup for existing subscriptions
   - `createUserSubscription`: Sets up new user subscriptions

2. Firestore Structure:
   - Collection: `subscriptions`
   - Fields:
     - `bookLimit`: Current book limit
     - `booksRead`: Number of books accessed
     - `lastLimitIncrease`: Timestamp of last increase
     - `tier`: Subscription tier (free/premium)

3. Security Rules:
   - Users can read their own subscription data
   - Cloud Functions can update subscription data
   - No direct client-side updates to limits

## API Integrations

The app uses several APIs to provide comprehensive dictionary and translation features:

### Dictionary Services
- **WaniKani API**: Used for Japanese kanji lookup, providing:
  - Kanji meanings and readings
  - Meaning and reading mnemonics
  - Level information for learning progression
  
- **Jisho API**: Fallback Japanese dictionary service when WaniKani data is not available
  - Word definitions and readings
  - Parts of speech information

- **Goo Labs API**: Used for Japanese reading (furigana) generation
  - Converts kanji to hiragana readings
  - Supports complex Japanese text analysis

- **Free Dictionary API**: Used for English word definitions
  - Comprehensive English definitions
  - Parts of speech
  - Example sentences

### Translation Services
- **Google Translate API**: Used for:
  - Word translations in supported languages (French, Spanish, German, Italian)
  - Text-to-speech pronunciation in all supported languages
  - Cross-language definitions and examples

## Development Steps

### Completed
1. Project setup and initial architecture
2. Basic navigation implementation
3. Home page layout with horizontal book scrolling
4. Library page with search functionality
5. Book favoriting system
6. Profile page structure
7. Subscription system implementation
   - Free and premium tier features
   - Progressive book limit system
   - Automatic limit increases
   - Study feature access control
   - Upgrade flow with subscription page

### In Progress
8. Book model implementation
   - Multi-language support
   - Page structure (image + text + audio)
   - Reading progress tracking
   
### Upcoming
9. Book Reader Implementation
   - Landscape mode enforcement
   - Split view (image | text)
   - Language selector
   - Audio playback controls
   - Page navigation

10. AI Integration
    - Story generation system
    - Image generation for each page
    - Text-to-speech in multiple languages

11. Content Management
    - Book creation interface
    - Content translation system
    - Audio file management

12. UI/UX Enhancements
    - Reading progress indicators
    - Animations and transitions
    - Theme customization
    - Accessibility features

13. Advanced Features
    - Reading statistics
    - Bookmarks and notes
    - Social sharing
    - Reading achievements

## Getting Started

[Installation and setup instructions will go here]

## Contributing

[Contribution guidelines will go here]

## License
