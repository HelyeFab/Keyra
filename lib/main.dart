import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:Keyra/features/dictionary/data/services/translation_service.dart';
import 'package:Keyra/features/dictionary/data/services/translation_service_singleton.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'features/notifications/services/notification_service.dart';
import 'core/services/preferences_service.dart';
import 'core/ui_language/bloc/ui_language_bloc.dart';
import 'core/ui_language/translations/ui_translations.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/presentation/bloc/connectivity_bloc.dart';
import 'core/presentation/widgets/connectivity_monitor.dart';
import 'core/presentation/bloc/language_bloc.dart';
import 'features/subscription/data/repositories/subscription_repository.dart';
import 'features/subscription/application/subscription_service.dart';
import 'features/subscription/presentation/bloc/subscription_bloc.dart';
import 'features/subscription/presentation/bloc/subscription_event.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';
import 'features/navigation/presentation/pages/navigation_page.dart';
import 'features/books/domain/models/book.dart';
import 'features/books/domain/models/book_language.dart';
import 'features/books/domain/models/book_page.dart';

Future<void> initServices() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive adapters in correct order
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BookAdapter());
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookLanguageAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BookPageAdapter());

    // Initialize translation service
    Logger.log('Starting translation service initialization...');
    final translationService = TranslationService(
      apiKey: dotenv.env['GOOGLE_TRANSLATE_API_KEY'] ?? '',
    );
    TranslationServiceSingleton.instance = translationService;
    Logger.log('Translation service initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize services', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize core services
    await initServices();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize preferences service
    final preferencesService = await PreferencesService.init();

    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Initialize Firebase Auth and wait for initial state
    final auth = FirebaseAuth.instance;
    await auth.authStateChanges().first;

    // Initialize repositories and services
    final subscriptionRepository = SubscriptionRepository();
    final subscriptionService = SubscriptionService(
      subscriptionRepository: subscriptionRepository,
    );
    final authRepository = FirebaseAuthRepository(
      subscriptionService: subscriptionService,
    );

    // Initialize UI language bloc
    final prefs = await SharedPreferences.getInstance();
    final uiLanguageBloc = UiLanguageBloc(prefs);

    // Initialize language bloc
    final languageBloc = await LanguageBloc.create();

    // Load saved language or detect system language
    uiLanguageBloc.add(LoadSavedUiLanguageEvent());

    // Initialize connectivity monitoring
    final connectivityBloc = ConnectivityBloc();
    connectivityBloc.add(ConnectivityStartMonitoring());

    runApp(
      MultiProvider(
        providers: [
          Provider<SharedPreferences>.value(value: prefs),
          Provider<NotificationService>.value(value: notificationService),
          Provider<TranslationService>(
            create: (_) => TranslationServiceSingleton.instance,
            lazy: false,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ThemeBloc(prefs),
            ),
            BlocProvider<UiLanguageBloc>.value(value: uiLanguageBloc),
            BlocProvider<LanguageBloc>.value(value: languageBloc),
            BlocProvider(
              create: (context) {
                final bloc = AuthBloc(
                  authRepository: authRepository,
                );
                bloc.add(const AuthBlocEvent.startAuthListening());
                return bloc;
              },
            ),
            BlocProvider(
              create: (context) => SubscriptionBloc(
                subscriptionRepository: subscriptionRepository,
              )..add(const SubscriptionEvent.started()),
            ),
            BlocProvider<ConnectivityBloc>.value(value: connectivityBloc),
          ],
          child: BlocBuilder<UiLanguageBloc, UiLanguageState>(
            builder: (context, uiLanguageState) {
              return UiTranslations(
                currentLanguage: uiLanguageState.languageCode,
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return ConnectivityMonitor(
                      child: MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Keyra',
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,
                        themeMode: themeState.themeMode,
                        home: SplashScreen(
                          isInitialized: true,
                          isFirstLaunch: preferencesService.isFirstLaunch,
                          preferencesService: preferencesService,
                        ),
                        routes: {
                          '/navigation': (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<AuthBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<UiLanguageBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<LanguageBloc>(),
                                  ),
                                  Provider<TranslationService>.value(
                                    value: context.read<TranslationService>(),
                                  ),
                                ],
                                child: const NavigationPage(),
                              ),
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  } catch (e) {
    rethrow;
  }
}
