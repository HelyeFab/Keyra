import 'package:flutter/material.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

class SentenceTranslationModal extends StatelessWidget {
  final String sentence;
  final String translation;
  final BookLanguage language;
  final DictionaryService dictionaryService;

  const SentenceTranslationModal({
    super.key,
    required this.sentence,
    required this.translation,
    required this.language,
    required this.dictionaryService,
  });

  static Future<void> show(
    BuildContext context,
    String sentence,
    String translation,
    BookLanguage language,
    DictionaryService dictionaryService,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SentenceTranslationModal(
        sentence: sentence,
        translation: translation,
        language: language,
        dictionaryService: dictionaryService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.1,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with close button
          Container(
            padding: AppSpacing.paddingMd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original sentence
                  Row(
                    children: [
                      Text(
                        UiTranslations.of(context).translate('translation_modal_original'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.sectionTitle,
                            ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedVolumeMute01,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.black,
                          size: 24.0,
                        ),
                        onPressed: () {
                          dictionaryService.speakWord(sentence, language.code, context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Text(
                      sentence,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: AppSpacing.lineHeightLarge,
                          ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Translation section - only show if translation is not a "no translation needed" message
                  if (translation != UiTranslations.of(context).translate('no_translation_needed')) ...[
                    Text(
                      UiTranslations.of(context).translate('translation_modal_translation'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.sectionTitle,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Text(
                        translation,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: AppSpacing.lineHeightLarge,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
