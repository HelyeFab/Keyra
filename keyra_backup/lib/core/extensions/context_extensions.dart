import 'package:flutter/material.dart';
import '../ui_language/translations/ui_translations.dart';

extension BuildContextExtensions on BuildContext {
  UiTranslations get tr => UiTranslations.of(this);
}
