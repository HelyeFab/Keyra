import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(UiTranslations.of(context).translate('privacy_policy')),
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
              UiTranslations.of(context).translate('privacy_policy_content'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
