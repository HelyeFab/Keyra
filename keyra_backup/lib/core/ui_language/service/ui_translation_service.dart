import 'package:flutter/material.dart';
import '../translations/ui_translations.dart';

class UiTranslationService {
  static String translate(BuildContext context, String key, [List<String>? args, bool listen = true]) {
    final uiTranslations = UiTranslations.of(context);
    var text = uiTranslations.translate(key);
    
    if (args != null) {
      for (var i = 0; i < args.length; i++) {
        text = text.replaceAll('{$i}', args[i]);
      }
    }
    
    return text;
  }
}
