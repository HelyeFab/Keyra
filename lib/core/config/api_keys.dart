import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get dictionaryApiKey => dotenv.env['DICTIONARY_API_KEY'] ?? '';
  static String get translationApiKey => dotenv.env['TRANSLATION_API_KEY'] ?? '';
  static String get googleApiKey => dotenv.env['GOOGLE_TRANSLATE_API_KEY'] ?? '';
  static String get gooLabsApiKey => dotenv.env['GO_API_KEY'] ?? '';
}
