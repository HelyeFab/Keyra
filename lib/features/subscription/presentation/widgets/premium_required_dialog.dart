import 'package:flutter/material.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../pages/subscription_page.dart';

class PremiumRequiredDialog extends StatelessWidget {
  const PremiumRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        UiTranslations.of(context).translate('premium_feature'),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      content: Text(
        UiTranslations.of(context).translate('premium_feature_desc'),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            UiTranslations.of(context).translate('maybe_later'),
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) => Column(
                  children: [
                    AppBar(
                      title: const Text('Subscription'),
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: const SubscriptionPage(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Text(
            UiTranslations.of(context).translate('upgrade_now'),
          ),
        ),
      ],
    );
  }
}
