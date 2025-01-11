class PreferencesService {
  final String appLanguage;
  bool hasSeenOnboarding;

  PreferencesService({
    this.appLanguage = 'en',
    this.hasSeenOnboarding = false,
  });

  static Future<PreferencesService> init() async {
    return PreferencesService();
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    hasSeenOnboarding = value;
  }
}
