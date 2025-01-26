import 'package:flutter/material.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/japanese_word_definition_modal.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/jisho_meanings_widget.dart';
import 'package:Keyra/features/dictionary/presentation/providers/jisho_meanings_provider.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

@immutable
class EnhancedJapaneseModalContent extends StatelessWidget {
  final String word;
  final BookLanguage language;

  const EnhancedJapaneseModalContent({
    super.key,
    required this.word,
    required this.language,
  });

  /// Shows the enhanced Japanese modal with Jisho meanings
  static Future<void> show(
    BuildContext context,
    String word,
    BookLanguage language,
  ) {
    final height = MediaQuery.of(context).size.height * 0.6;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JishoMeaningsProvider(
        child: SizedBox(
          height: height,
          child: EnhancedJapaneseModalContent(
            word: word,
            language: language,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  JapaneseWordDefinitionModal(
                    word: word,
                    language: language,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Jisho',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: JishoMeaningsWidget(
                          word: word,
                          theme: Theme.of(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
