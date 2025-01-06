import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../auth/data/repositories/firebase_auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_page_widget.dart';
import '../../../../core/services/preferences_service.dart';

class OnboardingPage extends StatefulWidget {
  final PreferencesService preferencesService;

  const OnboardingPage({
    super.key,
    required this.preferencesService,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      onboardingPages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onGetStarted() async {
    // Mark onboarding as seen
    await widget.preferencesService.setHasSeenOnboarding(true);

    if (!mounted) return;

    // Navigate to auth page with proper providers
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryProvider(
          create: (context) => FirebaseAuthRepository(),
          child: BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<FirebaseAuthRepository>(),
            ),
            child: const AuthPage(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                data: onboardingPages[index],
              );
            },
          ),

          // Bottom navigation and controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                      (index) => Semantics(
                        label: 'Page ${index + 1} of ${onboardingPages.length}',
                        selected: _currentPage == index,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Navigation buttons
                  if (_currentPage == onboardingPages.length - 1)
                    // Center the Get Started button when on last page
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Semantics(
                          button: true,
                          label: 'Complete onboarding and get started',
                          child: ElevatedButton(
                            onPressed: _onGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              minimumSize: const Size(200, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Get Started'),
                          ),
                        ),
                      ),
                    )
                  else
                    // Show Skip and Next buttons on other pages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          button: true,
                          label: 'Skip onboarding',
                          child: TextButton(
                            onPressed: _skipToEnd,
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              minimumSize: const Size(88, 48),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Skip'),
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: 'Next page',
                          child: ElevatedButton(
                            onPressed: () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              minimumSize: const Size(88, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
