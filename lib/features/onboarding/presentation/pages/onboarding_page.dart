import 'package:flutter/material.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_page_widget.dart';

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

  void _onNextPressed() async {
    if (_currentPage < getOnboardingPages(context).length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as seen
      await widget.preferencesService.setHasSeenOnboarding(true);
      
      if (!mounted) return;
      
      // Navigate to auth page
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = getOnboardingPages(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(data: pages[index]);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 200, // Fixed width for the button
                  child: FilledButton(
                    onPressed: _onNextPressed,
                    child: Text(
                      _currentPage == pages.length - 1 
                          ? UiTranslations.of(context).translate('onboarding_get_started')
                          : UiTranslations.of(context).translate('next'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
