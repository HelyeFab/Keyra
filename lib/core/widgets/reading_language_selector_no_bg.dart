import 'package:flutter/material.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:hugeicons/hugeicons.dart';
import '../ui_language/translations/ui_translations.dart';

class ReadingLanguageSelectorNoBg extends StatelessWidget {
  final BookLanguage? currentLanguage;
  final void Function(BookLanguage?) onLanguageChanged;
  final bool showAllOption;

  const ReadingLanguageSelectorNoBg({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    this.showAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final translations = UiTranslations.of(context);
    final allLanguagesText = translations.translate('common_all_languages');
    final selectLanguageText = translations.translate('select_reading_language');
    
    final currentSelection = currentLanguage == null
        ? const LanguageSelection(isAll: true)
        : LanguageSelection(language: currentLanguage);

    return PopupMenuButton<LanguageSelection>(
      tooltip: selectLanguageText,
      initialValue: currentSelection,
      onSelected: (selection) {
        onLanguageChanged(selection.language);
      },
      itemBuilder: (context) {
        final items = <PopupMenuItem<LanguageSelection>>[];
        
        if (showAllOption) {
          items.add(
            PopupMenuItem(
              value: const LanguageSelection(isAll: true),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 24),
                  const SizedBox(width: 12),
                  Text(allLanguagesText),
                ],
              ),
            ),
          );
        }
        
        items.addAll(
          BookLanguage.values.map(
            (language) => PopupMenuItem(
              value: LanguageSelection(language: language),
              child: Row(
                children: [
                  Image.asset(
                    language.flagAsset,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(language.displayName),
                ],
              ),
            ),
          ),
        );
        
        return items;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentLanguage != null) ... [
              Image.asset(
                currentLanguage!.flagAsset,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                currentLanguage!.code.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else ... [
              Icon(
                Icons.language,
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                allLanguagesText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(width: 8),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}

// Keep the LanguageSelection class in the same file since it's only used here
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
    return other is LanguageSelection &&
        other.language == language &&
        other.isAll == isAll;
  }

  @override
  int get hashCode => language.hashCode ^ isAll.hashCode;
}