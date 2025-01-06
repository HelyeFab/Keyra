import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/config/app_strings.dart';

class SplashScreen extends StatefulWidget {
  final bool isInitialized;
  final bool isFirstLaunch;
  final PreferencesService preferencesService;

  const SplashScreen({
    super.key,
    required this.isInitialized,
    required this.isFirstLaunch,
    required this.preferencesService,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  String _currentMessage = "";
  int _currentGroupIndex = 0;
  int _currentLanguageIndex = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen initState - isFirstLaunch: ${widget.isFirstLaunch}');
    
    // Start with the first message in English
    _currentMessage = AppStrings.splashMessages[0][AppStrings.englishIndex];

    // Update message every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          // Update language index first
          _currentLanguageIndex = (_currentLanguageIndex + 1) % 5;

          // If we've shown all languages for current message, move to next message
          if (_currentLanguageIndex == 0) {
            _currentGroupIndex = (_currentGroupIndex + 1) % AppStrings.splashMessages.length;
          }

          _currentMessage = AppStrings.splashMessages[_currentGroupIndex][_currentLanguageIndex];
        });
      }
    });

    // Navigate after delay - now 10 seconds for both cases
    Future.delayed(
      const Duration(seconds: 10),
      () async {
        if (mounted) {
          _timer?.cancel();
          debugPrint('Navigating - isFirstLaunch: ${widget.isFirstLaunch}');
          
          // Check auth state first
          final user = FirebaseAuth.instance.currentUser;
          
          if (!mounted) return;

          if (user != null) {
            // User is logged in, go directly to navigation
            Navigator.pushReplacementNamed(context, '/navigation');
          } else if (widget.isFirstLaunch) {
            // First launch, go to onboarding
            Navigator.pushReplacementNamed(context, '/onboarding');
          } else {
            // Not first launch and not logged in, check onboarding status
            final hasSeenOnboarding = await widget.preferencesService.hasSeenOnboarding;
            if (!mounted) return;
            
            if (hasSeenOnboarding) {
              Navigator.pushReplacementNamed(context, '/navigation');
            } else {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // Pastel light purple
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontFamily: 'FascinateInline',
                fontSize: 57,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.primary,
                letterSpacing: -0.25,
              ),
            ),
            Text(
              AppStrings.appTagline,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            Lottie.asset(
              'assets/loader/animation_1734447560170.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _currentMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
