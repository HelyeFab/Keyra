import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/services/preferences_service.dart';
import 'core/config/app_strings.dart';
import 'core/theme/color_schemes.dart';
import 'core/ui_language/translations/ui_translations.dart';

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
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  String _currentMessage = "";
  int _currentGroupIndex = 0;
  int _currentLanguageIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen initState - isFirstLaunch: ${widget.isFirstLaunch}');
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    
    _controller.forward();
    
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        children: [
          const SizedBox(height: 32),
          // Top half with image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                height: size.height * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/onboarding/keyra01.png',
                        fit: BoxFit.cover,
                      ),
                      // Subtle gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom content
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withBlue(255),
              ],
            ).createShader(bounds),
            child: Text(
              AppStrings.appName,
              style: const TextStyle(
                fontFamily: 'FascinateInline',
                fontSize: 57,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: -0.25,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            UiTranslations.of(context).translate('app_tagline'),
            style: TextStyle(
              fontFamily: 'Playwrite',
              fontSize: 20,
              color: theme.colorScheme.primary.withOpacity(0.8),
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(flex: 1),
          SizedBox(
            height: size.height * 0.3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/loader/animation_1734447560170.json',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 16),
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
          ),
          const Spacer(flex: 1),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
