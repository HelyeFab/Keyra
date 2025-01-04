import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/menu_button.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../features/badges/presentation/widgets/badge_display.dart';
import '../../../../features/badges/presentation/bloc/badge_bloc.dart';
import '../../../../features/badges/presentation/bloc/badge_state.dart';
import 'session/study_session_page.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../widgets/study_progress_card.dart';
import '../widgets/dialog/no_saved_words_dialog.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  void _startStudySession(BuildContext context, BookLanguage? language) async {
    final savedWordsRepo = context.read<SavedWordsRepository>();
    final words = await savedWordsRepo.getSavedWordsList(
      language: language?.code.toLowerCase(),
    );

    if (!context.mounted) return;

    if (words.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudySessionPage(
            words: words,
          ),
        ),
      );
    } else {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => NoSavedWordsDialog(
          showLanguageSpecific: language != null,
          languageCode: language?.code,
        ),
      );
    }
  }

  Widget _buildTipCard(BuildContext context, IconData icon, String title, String description, Color color) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.sectionTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: GradientBackground(
        pageIndex: 2,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BlocBuilder<BadgeBloc, BadgeState>(
                  builder: (context, state) {
                    return state.map(
                      initial: (_) => const SizedBox.shrink(),
                      loaded: (loaded) => BadgeDisplay(
                        level: loaded.progress.currentLevel,
                      ),
                      levelingUp: (levelingUp) => BadgeDisplay(
                        level: levelingUp.progress.currentLevel,
                      ),
                    );
                  },
                ),
              ),
              actions: const [
                MenuButton(),
                SizedBox(width: 16),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StudyProgressCard(
                            onLanguageSelected: (language) => _startStudySession(context, language),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            UiTranslations.of(context).translate('study_tips'),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: context.read<ThemeBloc>().state.useGradientTheme 
                                ? Colors.white 
                                : AppColors.sectionTitle,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTipCard(
                            context,
                            Icons.timer,
                            UiTranslations.of(context).translate('regular_practice'),
                            UiTranslations.of(context).translate('regular_practice_desc'),
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildTipCard(
                            context,
                            Icons.psychology,
                            UiTranslations.of(context).translate('spaced_repetition'),
                            UiTranslations.of(context).translate('spaced_repetition_desc'),
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildTipCard(
                            context,
                            Icons.auto_stories,
                            UiTranslations.of(context).translate('context_learning'),
                            UiTranslations.of(context).translate('context_learning_desc'),
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
