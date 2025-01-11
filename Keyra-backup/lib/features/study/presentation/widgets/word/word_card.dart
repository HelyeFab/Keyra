import 'package:flutter/material.dart';
import '../../../../../core/theme/color_schemes.dart';
import '../../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../../features/books/domain/models/book_language.dart';
import '../../../../../features/dictionary/domain/models/saved_word.dart';

class WordCard extends StatelessWidget {
  final SavedWord word;
  final Function(BookLanguage?) onLanguageSelected;

  const WordCard({
    super.key,
    required this.word,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = word.word.length % AppColors.wordCardColors.length;
    final cardColor = AppColors.wordCardColors[colorIndex];

    return Card(
      elevation: 2,
      color: cardColor,
      child: InkWell(
        onTap: () => onLanguageSelected(BookLanguage.values.firstWhere(
          (lang) => lang.code == word.language,
          orElse: () => BookLanguage.english,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    word.word,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Image.asset(
                    BookLanguage.values
                        .firstWhere(
                          (lang) => lang.code == word.language,
                          orElse: () => BookLanguage.english,
                        )
                        .flagAsset,
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${UiTranslationService.translate(context, 'common_definition')}: ${word.definition}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (word.examples.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${UiTranslationService.translate(context, 'common_examples')}:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                ...word.examples.map(
                  (example) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      '• $example',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
