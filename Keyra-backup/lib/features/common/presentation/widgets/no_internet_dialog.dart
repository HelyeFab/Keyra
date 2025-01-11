import 'package:flutter/material.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        UiTranslationService.translate(context, 'connection_error', null, false),
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
            UiTranslationService.translate(
              context, 
              'no_internet_message', 
              null, 
              false
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            UiTranslationService.translate(context, 'ok', null, false)
          ),
        ),
      ],
    );
  }
}
