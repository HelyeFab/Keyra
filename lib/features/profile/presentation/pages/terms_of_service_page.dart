import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(UiTranslations.of(context).translate('terms_of_service')),
            centerTitle: true,
            leading: IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24.0,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              UiTranslations.of(context).translate('terms_of_service_content'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
