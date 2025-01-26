import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import 'no_saved_words_dialog.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final List<String> languages;
  final Function(String?) onLanguageSelected;

  const LanguageSelectionDialog({
    super.key,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get translations upfront
    final studyWordsText = UiTranslationService.translate(context, 'dashboard_study_words');
    final allLanguagesText = UiTranslationService.translate(context, 'common_all_languages');

    return AlertDialog(
      title: Text(studyWordsText),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            // All languages option
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(allLanguagesText),
              onTap: () {
                Navigator.pop(context);
                onLanguageSelected(null);
              },
            ),
            const Divider(),
            // Individual language options
            ...languages.map((language) {
              final bookLanguage = BookLanguage.values.firstWhere(
                (l) => l.code == language.toLowerCase(),
                orElse: () => BookLanguage.english,
              );
              return ListTile(
                leading: Image.asset(
                  bookLanguage.flagAsset,
                  width: 24,
                  height: 24,
                ),
                title: Text(bookLanguage.displayName),
                onTap: () {
                  final savedWordsRepo = context.read<SavedWordsRepository>();
                  savedWordsRepo.getWordProgressCounts().first.then((counts) {
                    final total = counts.values.fold(0, (sum, count) => sum + count);
                    
                    if (total == 0) {
                      // Case 1: No saved words at all
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => NoSavedWordsDialog(
                          showLanguageSpecific: false,
                          languageCode: language,
                        ),
                      );
                    } else {
                      // Check if there are words in the selected language
                      final wordsInLanguage = counts[language] ?? 0;
                      if (wordsInLanguage == 0) {
                        // Case 2: Has words but not in this language
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                        builder: (context) => NoSavedWordsDialog(
                          showLanguageSpecific: true,
                          languageCode: language,
                        ),
                        );
                      } else {
                        Navigator.pop(context);
                        onLanguageSelected(language);
                      }
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
