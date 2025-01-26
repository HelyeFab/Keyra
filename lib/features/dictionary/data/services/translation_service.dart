import 'package:Keyra/core/utils/logger.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
  final String _apiKey;

  TranslationService({required String apiKey}) : _apiKey = apiKey;

  Future<String> translateText(String text, BookLanguage fromLanguage, {String? targetLanguage}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        body: {
          'q': text,
          'source': fromLanguage.code,
          'target': targetLanguage ?? 'en', // Use provided target language or default to English
          'format': 'text',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translation = data['data']['translations'][0]['translatedText'];
        return translation;
      } else {
        Logger.error(
          'Translation failed with status ${response.statusCode}',
          error: response.body,
        );
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      Logger.error('Translation error', error: e);
      throw Exception('Failed to translate text');
    }
  }
}
