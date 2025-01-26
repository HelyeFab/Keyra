import 'dart:async';
import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/color_schemes.dart';
import 'core/theme/text_themes.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';

class BubblePainter extends CustomPainter {
  final Color color;
  final bool drawShadow;

  BubblePainter({this.color = AppColors.splashKeyraText, this.drawShadow = true});

  @override
  void paint(Canvas canvas, Size size) {
    if (drawShadow) {
      final shadowPaint = Paint()
        ..color = AppColors.splashBubbleShadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      final shadowPath = Path();
      
      // Main bubble body
      shadowPath.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.width, size.height - 10),
          const Radius.circular(20),
        ),
      );

      // Add the pointer to the same path
      shadowPath.moveTo(size.width / 2 - 6, size.height - 10);
      shadowPath.lineTo(size.width / 2 + 1, size.height + 1);
      shadowPath.lineTo(size.width / 2 + 8, size.height - 10);
      shadowPath.close();
      
      canvas.drawPath(shadowPath, shadowPaint);
    }

    // Create the fill path (includes both bubble and pointer)
    final fillPath = Path();
    
    // Draw the main rounded rectangle
    fillPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height - 10),
        const Radius.circular(20),
      ),
    );

    // Add the pointer to the fill path
    fillPath.moveTo(size.width / 2 - 6, size.height - 10);
    fillPath.lineTo(size.width / 2, size.height - 2);
    fillPath.lineTo(size.width / 2 + 6, size.height - 10);
    fillPath.close();

    // Fill the entire shape
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, paint);

    // Create the border path (excludes triangle base)
    final borderPath = Path();
    
    // Draw the main rounded rectangle border (excluding the bottom center)
    const radius = 20.0;
    borderPath.moveTo(size.width / 2 - 6, size.height - 10); // Start from left of pointer
    
    // Draw left side and top-left corner
    borderPath.lineTo(radius, size.height - 10);
    borderPath.arcToPoint(
      Offset(0, size.height - 10 - radius),
      radius: const Radius.circular(radius),
    );
    
    // Draw left side
    borderPath.lineTo(0, radius);
    
    // Draw top-left corner and top side
    borderPath.arcToPoint(
      const Offset(radius, 0),
      radius: const Radius.circular(radius),
    );
    borderPath.lineTo(size.width - radius, 0);
    
    // Draw top-right corner and right side
    borderPath.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );
    borderPath.lineTo(size.width, size.height - 10 - radius);
    
    // Draw bottom-right corner
    borderPath.arcToPoint(
      Offset(size.width - radius, size.height - 10),
      radius: const Radius.circular(radius),
    );
    
    // Complete the right side to the pointer
    borderPath.lineTo(size.width / 2 + 6, size.height - 10);
    
    // Draw the pointer sides (excluding the base)
    borderPath.lineTo(size.width / 2, size.height - 2);
    borderPath.lineTo(size.width / 2 - 6, size.height - 10);

    // Draw the border
    final borderPaint = Paint()
      ..color = AppColors.lightSurfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MessageBubble extends StatelessWidget {
  final String message;
  final double xFraction;
  final double yFraction;
  final double opacity;
  final String flagAsset;
  final double screenWidth;
  final double bubbleAreaHeight;

  const MessageBubble({
    super.key,
    required this.message,
    required this.xFraction,
    required this.yFraction,
    required this.opacity,
    required this.flagAsset,
    required this.screenWidth,
    required this.bubbleAreaHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate absolute positions within the bubble area
    final left = xFraction * screenWidth;
    final top = yFraction * bubbleAreaHeight;

    // Responsive font size and image size
    final fontSize = screenWidth * 0.05; // 5% of screen width
    final imageSize = screenWidth * 0.06; // 6% of screen width

    return Positioned(
      left: left,
      top: top,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.5, end: opacity),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(
          scale: value * 0.9 + 0.1,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        ),
        child: CustomPaint(
          painter: BubblePainter(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: bubbleAreaHeight * 0.04,
            ),
            constraints: BoxConstraints(
              minWidth: screenWidth * 0.3,
              maxWidth: screenWidth * 0.6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Image.asset(
                  flagAsset,
                  width: imageSize,
                  height: imageSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _isDictionaryInitialized = false;
  final List<Map<String, dynamic>> messages = [
    {
      'message': 'Hello',
      'xFraction': 0.03,
      'yFraction': 0.10,
      'flagAsset': 'assets/flags/united-kingdom.png',
    },
    {
      'message': 'Bonjour',
      'xFraction': 0.5,
      'yFraction': 0.05,
      'flagAsset': 'assets/flags/france.png',
    },
    {
      'message': 'こんにちは',
      'xFraction': 0.5,
      'yFraction': 0.35,
      'flagAsset': 'assets/flags/japan.png',
    },
    {
      'message': 'Hola',
      'xFraction': 0.05,
      'yFraction': 0.45,
      'flagAsset': 'assets/flags/spain.png',
    },
    {
      'message': 'Ciao',
      'xFraction': 0.6,
      'yFraction': 0.65,
      'flagAsset': 'assets/flags/italy.png',
    },
    {
      'message': 'Hallo',
      'xFraction': 0.2,
      'yFraction': 0.72,
      'flagAsset': 'assets/flags/germany.png',
    },
  ];

  final List<double> opacities = List.generate(6, (_) => 0.0);

  @override
  void initState() {
    super.initState();
    Logger.log('SplashScreen initState - isFirstLaunch: ${widget.isFirstLaunch}');

    _animateMessages();
    _initializeDictionary();

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (mounted) {
          _timer?.cancel();
          Logger.log('Navigating - isFirstLaunch: ${widget.isFirstLaunch}');

          // Wait for dictionary initialization to complete
          while (!_isDictionaryInitialized) {
            await Future.delayed(const Duration(milliseconds: 100));
          }

          if (!mounted) return;

          if (!widget.preferencesService.hasSeenOnboarding) {
            // Show onboarding for first time users
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingPage(
                  preferencesService: widget.preferencesService,
                ),
              ),
            );
          } else {
            // Navigate to main navigation which handles auth state
            Navigator.pushReplacementNamed(context, '/navigation');
          }
        }
      },
    );
  }

  void _animateMessages() {
    void startAnimation() {
      for (int i = 0; i < messages.length; i++) {
        Future.delayed(Duration(milliseconds: i * 500), () {
          if (mounted) {
            setState(() {
              opacities[i] = 1.0;
            });
          }
        });
      }

      Future.delayed(Duration(milliseconds: messages.length * 500 + 1500), () {
        if (mounted) {
          setState(() {
            for (int i = 0; i < opacities.length; i++) {
              opacities[i] = 0.0;
            }
          });
          Future.delayed(const Duration(milliseconds: 1000), startAnimation);
        }
      });
    }

    startAnimation();
  }

  Future<void> _initializeDictionary() async {
    try {
      Logger.log('Starting dictionary service initialization...');
      final dictionaryService = DictionaryService();
      
      await dictionaryService.initialize();
      if (!dictionaryService.isInitialized) {
        throw Exception('Dictionary service initialize() completed but isInitialized is still false');
      }
      Logger.log('Dictionary service initialized successfully');
      _isDictionaryInitialized = true;
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to initialize dictionary service',
        error: e,
        stackTrace: stackTrace,
      );
      // Rethrow to ensure we see the error
      rethrow;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final bubbleAreaHeight = screenHeight * 0.30;
            final imageAreaHeight = screenHeight * 0.42;
            final bottomAreaHeight = screenHeight * 0.38;

            return Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.5),
                  radius: 1.5,
                  stops: [0.0, 0.2, 0.6],
                  colors: [
                    AppColors.darkSurfaceVariant, // Lighter at center
                    AppColors.darkSurface, // Medium
                    AppColors.darkBackground, // Darkest at edges
                  ],
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: bottomAreaHeight,
                      decoration: const BoxDecoration(
                        color: AppColors.darkSurface,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.lightSurfaceVariant,
                            width: 1.0,
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.splashBoxShadow,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.06,
                        right: screenWidth * 0.06,
                        top: screenHeight * 0.08,
                        bottom: screenHeight * 0.04,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                fontFamily: AppTextTheme.headlineFont,
                                fontSize: screenHeight * 0.028,
                                fontWeight: FontWeight.w400,
                                color: AppColors.splashWelcomeText,
                              ),
                            ),
                            Text(
                              'KEYRA',
                              style: TextStyle(
                                fontFamily: AppTextTheme.appTitleFont,
                                fontSize: screenHeight * 0.072,
                                fontWeight: FontWeight.w400,
                                color: AppColors.splashKeyraText,
                                shadows: const [
                                  // Create border effect with 4 shadows
                                  Shadow(
                                    offset: Offset(-1.5, -1.5),
                                    color: AppColors.splashKeyraTextShadow,
                                    blurRadius: 0,
                                  ),
                                  Shadow(
                                    offset: Offset(1.5, -1.5),
                                    color: AppColors.splashKeyraTextShadow,
                                    blurRadius: 0,
                                  ),
                                  Shadow(
                                    offset: Offset(-1.5, 1.5),
                                    color: AppColors.splashKeyraTextShadow,
                                    blurRadius: 0,
                                  ),
                                  Shadow(
                                    offset: Offset(1.5, 1.5),
                                    color: AppColors.splashKeyraTextShadow,
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.012),
                            Text(
                              'Your journey to mastering languages starts here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: screenHeight * 0.020,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: bubbleAreaHeight * 1,
                    left: (screenWidth - screenWidth * 1.1) / 2,
                    child: SizedBox(
                      height: imageAreaHeight,
                      child: Image.asset(
                        'assets/images/splashscreen/keyra_splashscreen.png',
                        width: screenWidth * 1.1,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: bubbleAreaHeight,
                      child: Stack(
                        children: List.generate(
                          messages.length,
                          (index) {
                            final message = messages[index];
                            return MessageBubble(
                              message: message['message'] as String,
                              xFraction: message['xFraction'] as double,
                              yFraction: message['yFraction'] as double,
                              opacity: opacities[index],
                              flagAsset: message['flagAsset'] as String,
                              screenWidth: screenWidth,
                              bubbleAreaHeight: bubbleAreaHeight,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
