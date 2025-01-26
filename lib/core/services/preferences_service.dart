import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const String _appLanguageKey = 'appLanguage';

  final SharedPreferences _prefs;
  String appLanguage;
  bool hasSeenOnboarding;
  final bool _isFirstLaunch;

  PreferencesService._({
    required SharedPreferences prefs,
    required this.appLanguage,
    required this.hasSeenOnboarding,
    required bool isFirstLaunch,
  }) : _prefs = prefs,
       _isFirstLaunch = isFirstLaunch;

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_isFirstLaunchKey) ?? true;
    
    if (isFirstLaunch) {
      await prefs.setBool(_isFirstLaunchKey, false);
    }

    return PreferencesService._(
      prefs: prefs,
      appLanguage: prefs.getString(_appLanguageKey) ?? 'en',
      hasSeenOnboarding: prefs.getBool(_hasSeenOnboardingKey) ?? false,
      isFirstLaunch: isFirstLaunch,
    );
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    hasSeenOnboarding = value;
    await _prefs.setBool(_hasSeenOnboardingKey, value);
  }

  Future<void> setAppLanguage(String value) async {
    appLanguage = value;
    await _prefs.setString(_appLanguageKey, value);
  }

  bool get isFirstLaunch => _isFirstLaunch;
}
