import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui_language_bloc.dart';
import '../translations/ui_translations.dart';

class UiLanguageSelectorModal extends StatelessWidget {
  const UiLanguageSelectorModal({super.key});

  static final Map<String, String> _languages = {
    'en': 'English',
    'fr': 'Français',
    'de': 'Deutsch',
    'es': 'Español',
    'it': 'Italiano',
    'ja': '日本語',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, state) {
        final translations = UiTranslations.of(context);
        final currentLanguage = state.languageCode;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translations.translate('select_language'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final languageCode = _languages.keys.elementAt(index);
                    final languageName = _languages[languageCode]!;
                    final isSelected = currentLanguage == languageCode;

                    return ListTile(
                      leading: isSelected
                          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                          : const SizedBox(width: 24),
                      title: Text(languageName),
                      onTap: () {
                        context
                            .read<UiLanguageBloc>()
                            .add(ChangeUiLanguageEvent(languageCode));
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
