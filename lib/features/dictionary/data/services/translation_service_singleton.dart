import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Keyra/features/dictionary/data/services/translation_service.dart';

class TranslationServiceSingleton {
  static TranslationService? _instance;

  static TranslationService get instance {
    _instance ??= TranslationService(
      apiKey: dotenv.env['GOOGLE_TRANSLATE_API_KEY'] ?? '',
    );
    return _instance!;
  }

  static set instance(TranslationService service) {
    _instance = service;
  }
}
