import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/widgets/study_language_selector.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';

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

        final translations = UiTranslations.of(context);
        final studyProgressText = translations.translate('study_progress');
        final newText = translations.translate('word_status_new');
        final learningText = translations.translate('word_status_learning');
        final learnedText = translations.translate('word_status_learned');
        final totalWordsText = translations.translate('total_words');
        final startStudyingText = translations.translate('start_studying');

        return StreamBuilder<Map<String, int>>(
          stream: context.read<SavedWordsRepository>().getWordProgressCounts(),
          builder: (context, snapshot) {
            final counts = snapshot.data ?? {'new': 0, 'learning': 0, 'learned': 0};
            final total = counts.values.fold(0, (sum, count) => sum + count);

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
                            size: 28,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studyProgressText,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (total > 0)
                                Text(
                                  '$total $totalWordsText',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildProgressItem(
                            newText,
                            counts['new'] ?? 0,
                            Colors.blue,
                            theme,
                            Icons.fiber_new,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProgressItem(
                            learningText,
                            counts['learning'] ?? 0,
                            Colors.orange,
                            theme,
                            Icons.psychology,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProgressItem(
                            learnedText,
                            counts['learned'] ?? 0,
                            Colors.green,
                            theme,
                            Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                    if (total > 0) ...[
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (counts['learned'] ?? 0) / total,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 8,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!context.mounted) return;
                          
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocBuilder<UiLanguageBloc, UiLanguageState>(
                              builder: (context, state) {
                                final translations = UiTranslations.of(context);
                                final studyWordsText = translations.translate('dashboard_study_words');
                                final selectLanguageText = translations.translate('dashboard_select_language_to_study');
                                
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
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.surfaceContainerLowest,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          startStudyingText,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressItem(
    String label,
    int count,
    Color color,
    ThemeData theme,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 80, // Fixed width for consistency
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
