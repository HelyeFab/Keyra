# Development Steps - Keyra Books App

## Project Setup (Step 1)
1. Created new Flutter project:
   ```bash
   flutter create . --org com.keyra --platforms android,ios
   ```

2. Updated dependencies in `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.3
     equatable: ^2.0.5
     go_router: ^12.1.3
     dio: ^5.4.0
     hive: ^2.2.3
     hive_flutter: ^1.1.0
   ```

3. Set up project structure following clean architecture:
   ```
   lib/
   ├── core/
   │   ├── constants/
   │   ├── theme/
   │   ├── utils/
   │   └── widgets/
   ├── features/
   │   ├── auth/
   │   ├── books/
   │   ├── onboarding/
   │   ├── profile/
   │   └── premium/
   ```

## Theme Implementation (Step 2)
1. Created theme files:
   - `lib/core/theme/color_schemes.dart`: Defined color palette
   - `lib/core/theme/text_themes.dart`: Typography settings
   - `lib/core/theme/app_theme.dart`: Combined themes with Material 3

2. Key theme features:
   - Material 3 design system
   - Light/dark theme support
   - Custom color schemes
   - Consistent typography

## Onboarding Feature Implementation (Step 3)

### 1. Feature Structure
Created onboarding feature structure:
```
lib/features/onboarding/
├── presentation/
│   ├── models/
│   │   └── onboarding_data.dart
│   ├── pages/
│   │   └── onboarding_page.dart
│   └── widgets/
│       └── onboarding_page_widget.dart
```

### 2. Data Model
Created `OnboardingData` class in `onboarding_data.dart`:
- Properties: title, description, imagePath
- Predefined list of onboarding pages
- Easily extensible for additional pages

### 3. UI Components

#### OnboardingPageWidget
Created reusable widget for each onboarding page:
- Gradient background (temporary, replaceable with images)
- Centered content layout
- Semi-transparent text container
- Responsive design

Key features:
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(...)
  ),
  child: Column(
    children: [
      Text(data.title...),
      Text(data.description...)
    ]
  )
)
```

#### OnboardingPage
Implemented main onboarding screen with:
- PageView for swipeable pages
- Page indicators
- Skip button
- Get Started button

Key features:
1. Page Controller:
   ```dart
   final PageController _pageController = PageController();
   ```

2. Navigation Controls:
   - Skip button with semi-transparent background
   - Animated page indicators
   - Context-aware Get Started button

3. Bottom Controls:
   ```dart
   Container(
     decoration: BoxDecoration(
       gradient: LinearGradient(...)
     ),
     child: Column(
       children: [
         PageIndicators(...),
         GetStartedButton(...)
       ]
     )
   )
   ```

4. Animations:
   - Smooth page transitions
   - Animated page indicators
   - Gradient background

### 4. Integration
1. Updated `main.dart`:
   - Removed debug banner
   - Set OnboardingPage as initial route
   - Applied theme configuration

2. Navigation:
   - Temporary HomePage setup
   - Navigation logic in Get Started button

## Authentication Feature Implementation (Step 4)

### 1. Feature Structure
Created authentication feature structure:
```
lib/features/auth/
├── presentation/
│   ├── bloc/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── pages/
│   │   └── auth_page.dart
│   └── widgets/
│       ├── login_form.dart
│       └── register_form.dart
```

### 2. State Management Setup
1. Created AuthBloc with events and states:
   ```dart
   class AuthBloc extends Bloc<AuthEvent, AuthState> {
     AuthBloc() : super(AuthInitial()) {
       on<EmailSignInRequested>(_onEmailSignInRequested);
       on<EmailSignUpRequested>(_onEmailSignUpRequested);
       on<SignOutRequested>(_onSignOutRequested);
     }
   }
   ```

2. Defined Events:
   - EmailSignInRequested
   - EmailSignUpRequested
   - SignOutRequested

3. Defined States:
   - AuthInitial
   - AuthLoading
   - AuthAuthenticated
   - AuthError

### 3. UI Implementation

#### Auth Page
Created tabbed interface with:
- Login and Register tabs
- Material 3 design
- Error handling with SnackBar
- BlocProvider integration

#### Login Form
Implemented form with:
```dart
- Email field with validation
- Password field with visibility toggle
- Login button with loading state
- Forgot password button (placeholder)
```

Key features:
- Form validation
- Error messages
- Loading states
- Password visibility toggle

#### Register Form
Implemented form with:
```dart
- Full name field
- Email field with validation
- Password field with visibility toggle
- Confirm password field with matching validation
- Register button with loading state
```

Key features:
- Comprehensive form validation
- Password matching validation
- Loading states
- Password visibility toggles

### 4. Navigation Integration
1. Updated OnboardingPage:
   ```dart
   void _onGetStarted() {
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => const AuthPage()),
     );
   }
   ```

### 5. Form Validation
Implemented validation for:
- Email format
- Password length (minimum 6 characters)
- Password matching
- Required fields

## Social Authentication Implementation (Step 5)

### 1. Dependencies Added
```yaml
google_sign_in: ^6.1.6
sign_in_with_apple: ^5.0.0
crypto: ^3.0.3  # Required for Apple Sign In
```

### 2. Feature Structure
Added social authentication components:
```
lib/features/auth/
└── presentation/
    ├── widgets/
    │   └── social_sign_in_buttons.dart
    └── bloc/
        ├── auth_bloc.dart (updated)
        └── auth_event.dart (updated)
```

### 3. Components Implementation
1. Created SocialSignInButtons widget:
   - Divider with "OR" text
   - Google Sign-In button with logo
   - Apple Sign-In button (iOS only)
   - Platform-specific button display

2. Added Auth Events:
   ```dart
   - GoogleSignInRequested
   - AppleSignInRequested
   ```

3. Updated AuthBloc:
   - Added handlers for social sign-in events
   - Prepared structure for Firebase integration

### 4. UI Integration
- Added social buttons to both Login and Register forms
- Implemented responsive layout
- Added platform-specific button display (Apple Sign-In on iOS only)

### 5. Asset Management
- Created assets structure for social logos
- Updated pubspec.yaml with new asset paths

## Firebase Authentication Implementation (Step 6)

### 1. Dependencies Added
```yaml
# Firebase
firebase_core: ^2.32.0
firebase_auth: ^4.16.0
cloud_firestore: ^4.17.5
google_sign_in: ^6.1.6
provider: ^6.1.1  # Added for dependency injection
```

### 2. Feature Structure
Added Firebase authentication components:
```
lib/features/auth/
├── data/
│   └── repositories/
│       └── firebase_auth_repository.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart (updated)
    │   └── auth_state.dart (updated)
    ├── pages/
    │   └── auth_page.dart (updated)
    └── widgets/
        ├── login_form.dart
        └── register_form.dart
```

### 3. Repository Implementation
- Created `FirebaseAuthRepository` to handle:
  - Email/password sign in
  - Email/password registration
  - Google sign in
  - Sign out
  - Error handling for various authentication scenarios

### 4. AuthBloc Updates
- Implemented event handlers for:
  - Email sign in
  - Email registration
  - Google sign in
  - Sign out
- Updated state management:
  - Made `userId` optional in `AuthAuthenticated` state
  - Added proper error handling

### 5. UI Integration
- Updated `main.dart`:
  - Initialize Firebase
  - Added repository provider for dependency injection
  - Added temporary `HomePage` implementation
- Modified `AuthPage`:
  - Added proper repository injection
  - Implemented navigation after successful authentication
  - Added error message display

### 6. Authentication Flow
1. User opens app → `OnboardingPage`
2. User navigates to `AuthPage`
3. User can choose between:
   - Login with email/password
   - Register with email/password
   - Sign in with Google
4. On successful authentication:
   - User is redirected to `HomePage`
   - User ID is stored in `AuthAuthenticated` state
5. User can sign out from `HomePage`

### 7. Error Handling
- Implemented user-friendly error messages for:
  - Invalid email
  - Wrong password
  - User not found
  - Weak password
  - Email already in use
  - Network errors
  - Google sign-in cancellation

### 8. Next Steps
- Implement email verification
- Add password reset functionality
- Create user profile management
- Add persistent authentication state
- Implement secure token storage

## Firebase Integration (Step 4)

### 1. Setup and Configuration
- Added Firebase dependencies to `pubspec.yaml`:
  ```yaml
  dependencies:
    firebase_core: ^latest_version
    firebase_auth: ^latest_version
  ```
- Generated Firebase configuration files using FlutterFire CLI
- Added `firebase_options.dart` to the project

### 2. Firebase Initialization
Implemented proper Firebase initialization sequence in `main.dart`:
```dart
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### 3. Firebase Auth Repository
Created repository pattern for Firebase authentication:
```
lib/features/auth/data/repositories/
└── firebase_auth_repository.dart
```

## Preferences Service Implementation (Step 5)

### 1. Service Structure
Created preferences service for managing app preferences:
```
lib/core/services/
└── preferences_service.dart
```

### 2. Key Features
- Used `flutter_secure_storage` for secure data persistence
- Implemented key-value storage for app preferences
- Added methods for managing onboarding status:
  ```dart
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  
  // Check if user has seen onboarding
  Future<bool> get hasSeenOnboarding async {
    final value = await _storage.read(key: _hasSeenOnboardingKey);
    return value == 'true';
  }

  // Mark onboarding as seen
  Future<void> setHasSeenOnboarding() async {
    await _storage.write(key: _hasSeenOnboardingKey, value: 'true');
  }
  ```

### 3. Service Initialization
- Added initialization with default values
- Implemented safe fallback for first-time users:
  ```dart
  static Future<PreferencesService> init() async {
    const storage = FlutterSecureStorage();
    final service = PreferencesService(storage);
    
    // Initialize with default value if not set
    final hasValue = await service._storage.containsKey(
      key: _hasSeenOnboardingKey
    );
    if (!hasValue) {
      await service._storage.write(
        key: _hasSeenOnboardingKey, 
        value: 'false'
      );
    }
    
    return service;
  }
  ```

## App Flow Implementation (Step 6)

### 1. Main App Structure
Updated `main.dart` to handle the complete initialization sequence:
1. Flutter bindings initialization
2. Firebase initialization with platform-specific options
3. Preferences service initialization
4. App launch with proper state management

### 2. Initialization Sequence
```dart
void main() async {
  // 1. Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 3. Run app with proper initialization
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize preferences service
  late Future<PreferencesService> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = PreferencesService.init();
  }
  
  // ... rest of the implementation
}
```

### 3. State Management Flow
1. App initialization (Flutter + Firebase)
2. Preferences service initialization
3. Check onboarding status
4. Show appropriate screen:
   - First time → Onboarding
   - After onboarding → Auth flow
   - Authenticated → Home page

## Library Feature Implementation (Step 6)

### 1. Library Page Structure
Created library feature structure:
```
lib/features/library/
├── presentation/
│   ├── pages/
│   │   └── library_page.dart
│   └── widgets/
│       └── book_card.dart
```

### 2. Search Functionality
Implemented search features:
- Text search with debouncing
- Real-time filtering
- Empty state handling
- Search results display

### 3. Favorites System
Added book favoriting capability:
- Toggle favorite status
- Favorite filter
- Persistent favorite state
- Visual feedback

## Book Model Implementation (Step 7) [In Progress]

### 1. Core Requirements
- Multi-language support (6 languages)
- Page-based content structure
- Audio integration
- Reading progress tracking

### 2. Model Structure
```dart
enum BookLanguage {
  english,
  french,
  spanish,
  italian,
  german,
  japanese
}

class BookPage {
  final String imageUrl;
  final Map<BookLanguage, String> textContent;
  final Map<BookLanguage, String> audioUrls;
  final int pageNumber;
}

class Book {
  final String id;
  final Map<BookLanguage, String> title;
  final String coverImage;
  final List<BookPage> pages;
  final BookLanguage defaultLanguage;
  
  // Reading state
  BookLanguage currentLanguage;
  int currentPage;
  bool isAudioPlaying;
}
```

### 3. Planned Features
1. Book Reader View:
   - Landscape mode enforcement
   - Split view (image | text)
   - Language selector
   - Audio playback
   - Page navigation

2. Content Generation:
   - AI story generation
   - Image generation
   - Text-to-speech conversion
   - Multi-language translations

3. Reading Progress:
   - Page tracking
   - Language preference
   - Audio state management
   - Bookmarks and notes

## Key Features Implemented
- Swipeable onboarding pages
- Page indicators with animations
- Skip functionality
- Get Started button
- Gradient backgrounds
- Material 3 theming
- Responsive design
- Authentication feature with login and register forms
- Social authentication with Google and Apple Sign-In
- Firebase authentication with email/password and Google sign-in

## Next Steps
1. Firebase Configuration:
   - Set up Firebase Console
   - Configure Android/iOS credentials
   - Add SHA-1 for Google Sign-In

2. User Profile:
   - Create user profile in Firestore
   - Store additional user data
   - Handle profile updates

3. Authentication Features:
   - Email verification
   - Password reset
   - Account linking
   - Profile picture upload

## Tips for Implementation
1. **Page Indicators**: Use `AnimatedContainer` for smooth transitions
2. **Gradient Background**: Layer with content using Stack widget
3. **Text Overlay**: Use semi-transparent container for better readability
4. **Navigation**: Consider implementing proper routing system before proceeding
5. **State Management**: Plan for user preferences to show onboarding only once
6. **Form Validation**: Use GlobalKey<FormState> for form validation
7. **Password Security**: Implement strong password requirements
8. **Error Handling**: Show user-friendly error messages
9. **State Management**: Use BlocListener for navigation and error messages
10. **UI/UX**: Add loading indicators and disable buttons during processing

## Common Issues and Solutions
1. **Page Indicator Visibility**: Add gradient background to bottom container
2. **Text Readability**: Use semi-transparent surface color
3. **Button Positioning**: Use Stack and Positioned widgets
4. **Responsive Layout**: Use MediaQuery for dynamic sizing
5. **Form Reset**: Clear form fields after successful submission
6. **Keyboard Handling**: Use SingleChildScrollView for scrolling when keyboard appears
7. **Password Visibility**: Toggle icon changes with password visibility
8. **Error Messages**: Show specific error messages for different validation cases

This implementation provides a solid foundation for an onboarding flow and authentication that can be easily customized and extended with additional features.


Next Steps:
Complete Firebase configuration
Implement user profile management
Add email verification and password reset
Develop book reader interface
Set up content generation pipeline
