import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  final FlutterSecureStorage _storage;

  PreferencesService(this._storage);

  static Future<PreferencesService> init() async {
    const storage = FlutterSecureStorage();
    final service = PreferencesService(storage);
    
    // Initialize with default value if not set
    final hasValue = await service._storage.containsKey(key: _hasSeenOnboardingKey);
    if (!hasValue) {
      await service._storage.write(key: _hasSeenOnboardingKey, value: 'false');
    }
    
    return service;
  }

  Future<bool> get hasSeenOnboarding async {
    final value = await _storage.read(key: _hasSeenOnboardingKey);
    return value == 'true';
  }

  Future<void> setHasSeenOnboarding() async {
    await _storage.write(key: _hasSeenOnboardingKey, value: 'true');
  }
}
