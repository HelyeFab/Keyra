import 'package:flutter/material.dart';
import '../../features/books/domain/models/book_language.dart';
import '../ui_language/service/ui_translation_service.dart';

// Custom class to handle both language and "all" states
class LanguageSelection {
  final BookLanguage? language;
  final bool isAll;

  const LanguageSelection({
    this.language,
    this.isAll = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LanguageSelection) return false;
    if (isAll && other.isAll) return true;
    return other.language == language;
  }

  @override
  int get hashCode => isAll ? 0 : language.hashCode;

  static LanguageSelection all() => const LanguageSelection(isAll: true);
  static LanguageSelection specific(BookLanguage language) =>
      LanguageSelection(language: language);
}

class StudyLanguageSelector extends StatelessWidget {
  final BookLanguage? currentLanguage;
  final void Function(BookLanguage?) onLanguageChanged;
  final bool showAllOption;

  const StudyLanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    this.showAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final allLanguagesText =
        UiTranslationService.translate(context, 'common_all_languages');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showAllOption)
          _buildLanguageOption(
            context,
            null,
            allLanguagesText,
            icon: const Icon(Icons.language, size: 24),
          ),
        ...BookLanguage.values.map(
          (language) => _buildLanguageOption(
            context,
            language,
            UiTranslationService.translate(context, 'language_${language.name.toLowerCase()}'),
            flagAsset: language.flagAsset,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    BookLanguage? language,
    String text, {
    Icon? icon,
    String? flagAsset,
  }) {
    final isSelected = language == currentLanguage || 
        (language == null && currentLanguage == null);

    return InkWell(
      onTap: () => onLanguageChanged(language),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (flagAsset != null)
              Image.asset(
                flagAsset,
                width: 24,
                height: 24,
              )
            else if (icon != null)
              icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
