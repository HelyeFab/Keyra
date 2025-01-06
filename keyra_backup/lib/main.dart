import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/books/domain/models/book.dart';
import 'features/books/domain/models/book_language.dart';
import 'features/books/domain/models/book_page.dart';
import 'features/books/data/services/book_cache_service.dart';
import 'features/books/data/services/book_cover_cache_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/badges/domain/repositories/badge_repository.dart';
import 'features/badges/data/repositories/badge_repository_impl.dart';
import 'features/badges/presentation/bloc/badge_bloc.dart';
import 'features/dictionary/data/repositories/saved_words_repository.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/dashboard/data/repositories/user_stats_repository.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'core/services/preferences_service.dart';
import 'core/presentation/bloc/language_bloc.dart';
import 'core/ui_language/bloc/ui_language_bloc.dart';
import 'core/ui_language/translations/ui_translations.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'features/books/data/repositories/firestore_populator.dart';
import 'features/library/presentation/pages/library_page.dart';
import 'features/study/presentation/pages/study_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'firebase_options.dart';
import 'features/dictionary/data/services/dictionary_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_screen.dart';
import 'dart:async';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/navigation/presentation/pages/navigation_page.dart';
import 'package:rxdart/rxdart.dart';

// Create stream controllers for initialization status
final _dictionaryInitController = StreamController<bool>.broadcast();
final _booksInitController = StreamController<bool>.broadcast();
final _userStatsInitController = StreamController<bool>.broadcast();

late BookCacheService _bookCacheService;
late FirestorePopulator _firestorePopulator;
late UserStatsRepository _userStatsRepository;

Future<void> initServices() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register Hive adapters in correct order
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BookAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(BookLanguageAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BookPageAdapter());
    
    // Initialize caches
    _bookCacheService = BookCacheService();
    await _bookCacheService.init();
  } catch (e) {
    print('Error initializing services: $e');
    rethrow;
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize core services
    await initServices();
    await dotenv.load(fileName: '.env');

    // Initialize preferences service
    final preferencesService = await PreferencesService.init();

    // Initialize theme bloc
    final themeBloc = await ThemeBloc.create();

    // Initialize language bloc
    final languageBloc = await LanguageBloc.create();

    // Initialize UI language bloc
    final prefs = await SharedPreferences.getInstance();
    final uiLanguageBloc = UiLanguageBloc(prefs);
    uiLanguageBloc.add(LoadSavedUiLanguageEvent());

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Check if dictionary is already initialized
    final dictionaryService = DictionaryService();
    final isFirstLaunch = !dictionaryService.isDictionaryInitialized;
    debugPrint('Is first launch: $isFirstLaunch');

    // Initialize Firebase Auth and wait for initial state
    final auth = FirebaseAuth.instance;
    await auth.authStateChanges().first;
    
    // Sign in anonymously if no user is signed in
    if (auth.currentUser == null) {
      try {
        await auth.signInAnonymously();
        print('Signed in anonymously');
      } catch (e) {
        print('Error signing in anonymously: $e');
      }
    }

    // Initialize repositories with caches
    _firestorePopulator = FirestorePopulator(
      bookCacheService: _bookCacheService,
      coverCacheManager: BookCoverCacheManager.instance
    );
    _userStatsRepository = UserStatsRepository();

    // Start preloading books in background
    if (auth.currentUser != null) {
      // Use Future.microtask to avoid immediate execution
      Future.microtask(() async {
        try {
          await _firestorePopulator.preloadBooks();
          print('Books preloaded successfully');
          if (!_booksInitController.isClosed) {
            _booksInitController.add(true);
          }
        } catch (e) {
          print('Error preloading books: $e');
          if (!_booksInitController.isClosed) {
            _booksInitController.add(true); // Allow proceeding even on error
          }
        }
      });

      // Initialize user stats in background
      Future.microtask(() async {
        try {
          await _userStatsRepository.getUserStats();
          print('User stats initialized successfully');
          if (!_userStatsInitController.isClosed) {
            _userStatsInitController.add(true);
          }
        } catch (e) {
          print('Error initializing user stats: $e');
          if (!_userStatsInitController.isClosed) {
            _userStatsInitController.add(true); // Allow proceeding even on error
          }
        }
      });
    } else {
      // No user, mark as initialized
      _booksInitController.add(true);
      _userStatsInitController.add(true);
    }

    // If it's first launch, start dictionary initialization in background
    if (isFirstLaunch) {
      debugPrint('Starting dictionary initialization in background...');
      Future.microtask(() async {
        try {
          await dictionaryService.initialize();
          debugPrint('Dictionary initialization complete');
          if (!_dictionaryInitController.isClosed) {
            _dictionaryInitController.add(true);
          }
        } catch (e) {
          debugPrint('Error initializing dictionary: $e');
          if (!_dictionaryInitController.isClosed) {
            _dictionaryInitController.add(true); // Allow proceeding even on error
          }
        }
      });
    } else {
      // Dictionary already initialized
      _dictionaryInitController.add(true);
    }

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SavedWordsRepository>(
            create: (context) => SavedWordsRepository(),
          ),
          RepositoryProvider<BadgeRepository>(
            create: (context) => BadgeRepositoryImpl(),
          ),
          RepositoryProvider<UserStatsRepository>(
            create: (context) => _userStatsRepository,
          ),
          RepositoryProvider<DictionaryService>(
            create: (context) => dictionaryService,
          ),
          RepositoryProvider<BookCacheService>(
            create: (context) => _bookCacheService,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LanguageBloc>.value(value: languageBloc),
            BlocProvider<UiLanguageBloc>.value(value: uiLanguageBloc),
            BlocProvider(
              create: (context) {
                final bloc = AuthBloc(
                  authRepository: FirebaseAuthRepository(),
                );
                bloc.add(const AuthBlocEvent.startAuthListening());
                return bloc;
              },
            ),
            BlocProvider(
              create: (context) => BadgeBloc(
                badgeRepository: context.read<BadgeRepository>(),
                savedWordsRepository: context.read<SavedWordsRepository>(),
                userStatsRepository: context.read<UserStatsRepository>(),
              ),
            ),
          ],
          child: BlocBuilder<UiLanguageBloc, UiLanguageState>(
            builder: (context, uiLanguageState) {
              return UiTranslations(
                currentLanguage: uiLanguageState.languageCode,
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Keyra',
                      theme: AppTheme.lightTheme,
                      darkTheme: AppTheme.darkTheme,
                      themeMode: themeState.themeMode,
                      home: StreamBuilder<List<bool>>(
                        stream: Rx.combineLatest3(
                          _dictionaryInitController.stream,
                          _booksInitController.stream,
                          _userStatsInitController.stream,
                          (a, b, c) => [a, b, c],
                        ),
                        initialData: [!isFirstLaunch, false, false],
                        builder: (context, snapshot) {
                          final isInitialized = snapshot.data?.every((init) => init) ?? false;
                          return SplashScreen(
                            isInitialized: isInitialized,
                            isFirstLaunch: isFirstLaunch,
                            preferencesService: preferencesService,
                          );
                        },
                      ),
                      routes: {
                        '/home': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: const HomePage(),
                        ),
                        '/library': (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<AuthBloc>(),
                            ),
                            BlocProvider(
                              create: (context) => DashboardBloc(
                                userStatsRepository: context.read<UserStatsRepository>(),
                              ),
                            ),
                            BlocProvider.value(
                              value: context.read<BadgeBloc>(),
                            ),
                          ],
                          child: const LibraryPage(),
                        ),
                        '/study': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: const StudyPage(),
                        ),
                        '/dashboard': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: const DashboardPage(),
                        ),
                        '/profile': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: const ProfilePage(),
                        ),
                        '/onboarding': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: OnboardingPage(preferencesService: preferencesService),
                        ),
                        '/navigation': (context) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: const NavigationPage(),
                        ),
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  } catch (e, stackTrace) {
    print('Error in app initialization: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
