import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import '../../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../../features/books/domain/models/book_language.dart';

class Flashcard extends StatelessWidget {
  final String word;
  final String definition;
  final List<String>? examples;
  final FlipCardController controller;
  final String language;

  const Flashcard({
    super.key,
    required this.word,
    required this.definition,
    this.examples,
    required this.controller,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        final languageCode = uiLanguageState.languageCode;
        return FlipCard(
          controller: controller,
          direction: FlipDirection.HORIZONTAL,
          front: _buildFrontCard(context, languageCode),
          back: _buildBackCard(context, languageCode),
        );
      },
    );
  }

  Widget _buildFrontCard(BuildContext context, String languageCode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              UiTranslationService.translate(context, 'language_${BookLanguage.fromCode(language).name.toLowerCase()}'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              UiTranslationService.translate(context, 'tap_to_see_definition'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(BuildContext context, String languageCode) {
    final definitionText = UiTranslationService.translate(context, 'definition');
    final examplesText = UiTranslationService.translate(context, 'examples');
    final tapToSeeWordText = UiTranslationService.translate(context, 'tap_to_see_word');
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$definitionText:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              definition,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.left,
            ),
            if (examples != null && examples!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '$examplesText:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              ...examples!.map((example) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '• $example',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
            ],
            const Spacer(),
            Center(
              child: Text(
                tapToSeeWordText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
