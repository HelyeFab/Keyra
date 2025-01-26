import 'package:flutter/material.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        UiTranslations.of(context).translate('connection_error'),
        style: theme.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            UiTranslations.of(context).translate('no_internet_message'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            UiTranslations.of(context).translate('ok')
          ),
        ),
      ],
    );
  }
}
