import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class AcknowledgmentsPage extends StatelessWidget {
  const AcknowledgmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        final languageCode = uiLanguageState.languageCode;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24.0,
              ),
            ),
            title: Text(UiTranslations.translations[languageCode]?['acknowledgments'] ?? 'Acknowledgments'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UiTranslations.translations[languageCode]?['special_thanks'] ?? 'Special Thanks',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildAcknowledgmentSection(
                  context,
                  UiTranslations.translations[languageCode]?['icons_section'] ?? 'Icons',
                  UiTranslations.translations[languageCode]?['icons_description'] ?? 'HugeIcons - Beautiful and consistent icon set\nFlatIcon - High quality icons and graphics',
                ),
                _buildAcknowledgmentSection(
                  context,
                  UiTranslations.translations[languageCode]?['animations_section'] ?? 'Animations',
                  UiTranslations.translations[languageCode]?['animations_description'] ?? 'Lottie Animation - "Free fox greetings Animation" by Solitudinem',
                ),
                _buildAcknowledgmentSection(
                  context,
                  UiTranslations.translations[languageCode]?['fonts_section'] ?? 'Fonts',
                  UiTranslations.translations[languageCode]?['fonts_description'] ?? 'FascinateInline - Unique and stylish font for our branding',
                ),
                _buildAcknowledgmentSection(
                  context,
                  UiTranslations.translations[languageCode]?['libraries_section'] ?? 'Open Source Libraries',
                  UiTranslations.translations[languageCode]?['libraries_description'] ?? 'Flutter and Dart communities for their amazing work',
                ),
                _buildAcknowledgmentSection(
                  context,
                  UiTranslations.translations[languageCode]?['contributors_section'] ?? 'Contributors',
                  UiTranslations.translations[languageCode]?['contributors_description'] ?? 'All the developers who have contributed to this project',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAcknowledgmentSection(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
