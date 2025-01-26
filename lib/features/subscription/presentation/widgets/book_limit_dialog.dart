import 'package:flutter/material.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../pages/subscription_page.dart';

class BookLimitDialog extends StatelessWidget {
  final int currentBooks;
  final int bookLimit;
  final DateTime? nextIncreaseDate;

  const BookLimitDialog({
    super.key,
    required this.currentBooks,
    required this.bookLimit,
    this.nextIncreaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        UiTranslations.of(context).translate('book_limit_reached'),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            UiTranslations.of(context).translate('book_limit_desc'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            UiTranslations.of(context)
                .translate('books_read_of_limit')
                .replaceAll('{0}', currentBooks.toString())
                .replaceAll('{1}', bookLimit.toString()),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (nextIncreaseDate != null) ...[
            const SizedBox(height: 8),
            Text(
              UiTranslations.of(context)
                  .translate('next_book_available')
                  .replaceAll('{0}', _formatDaysRemaining(nextIncreaseDate!)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
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

  String _formatDaysRemaining(DateTime nextIncrease) {
    final now = DateTime.now();
    final difference = nextIncrease.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours % 24;

    if (days > 0) {
      return '$days days';
    } else if (hours > 0) {
      return '$hours hours';
    } else {
      return 'soon';
    }
  }
}
