import 'package:flutter/material.dart';
import '../../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../../features/books/domain/models/book_language.dart';

class NoSavedWordsDialog extends StatelessWidget {
  final bool showLanguageSpecific;
  final String? languageCode;

  const NoSavedWordsDialog({
    super.key,
    this.showLanguageSpecific = false,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        UiTranslationService.translate(context, 'study_progress', null, false),
        style: theme.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            showLanguageSpecific
                ? UiTranslationService.translate(
                    context,
                    'no_saved_words_language_message',
                    [BookLanguage.values.firstWhere(
                      (l) => l.code.toLowerCase() == languageCode?.toLowerCase(),
                      orElse: () => BookLanguage.english,
                    ).displayName],
                    false
                  )
                : UiTranslationService.translate(context, 'no_saved_words_message', null, false),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(UiTranslationService.translate(context, 'ok', null, false)),
        ),
      ],
    );
  }
}
