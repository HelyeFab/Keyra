import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../core/widgets/study_language_selector.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';

class StudyProgressCard extends StatefulWidget {
  final void Function(BookLanguage?) onLanguageSelected;

  const StudyProgressCard({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  State<StudyProgressCard> createState() => _StudyProgressCardState();
}

class _StudyProgressCardState extends State<StudyProgressCard> {
  BookLanguage? _currentLanguage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiState) {
        final theme = Theme.of(context);

        // Get translations upfront
        final studyProgressText = UiTranslationService.translate(context, 'study progress');
        final newText = UiTranslationService.translate(context, 'new');
        final learningText = UiTranslationService.translate(context, 'learning');
        final learnedText = UiTranslationService.translate(context, 'learned');
        final totalWordsText = UiTranslationService.translate(context, 'total words');

        return StreamBuilder<Map<String, int>>(
          stream: context.read<SavedWordsRepository>().getWordProgressCounts(),
          builder: (context, snapshot) {
            final counts = snapshot.data ?? {'new': 0, 'learning': 0, 'learned': 0};
            final total = counts.values.fold(0, (sum, count) => sum + count);

            return Card(
              elevation: 4,
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  if (!context.mounted) return;
                  
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BlocBuilder<UiLanguageBloc, UiLanguageState>(
                      builder: (context, state) {
                        final studyWordsText = UiTranslationService.translate(context, 'dashboard_study_words');
                        final selectLanguageText = UiTranslationService.translate(context, 'dashboard_select_language_to_study');
                        
                        return AlertDialog(
                          title: Text(studyWordsText),
                          content: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectLanguageText,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: StudyLanguageSelector(
                                    currentLanguage: _currentLanguage,
                                    onLanguageChanged: (language) {
                                      setState(() {
                                        _currentLanguage = language;
                                      });
                                      Navigator.pop(dialogContext);
                                      widget.onLanguageSelected(language);
                                    },
                                    showAllOption: true,
                                    key: const Key('study_language_selector'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 24,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            studyProgressText,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Progress Items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProgressItem(
                            newText,
                            counts['new'] ?? 0,
                            Colors.blue,
                            theme
                          ),
                          _buildProgressItem(
                            learningText,
                            counts['learning'] ?? 0,
                            Colors.orange,
                            theme
                          ),
                          _buildProgressItem(
                            learnedText,
                            counts['learned'] ?? 0,
                            Colors.green,
                            theme
                          ),
                        ],
                      ),
                      if (total > 0) ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: (counts['learned'] ?? 0) / total,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ],
                      // Total words
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          '$total $totalWordsText',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressItem(String label, int count, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
