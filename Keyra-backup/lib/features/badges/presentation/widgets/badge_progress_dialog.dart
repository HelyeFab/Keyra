import 'package:flutter/material.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../badges/domain/models/badge_progress.dart';
import 'badge_display.dart';

class BadgeProgressDialog extends StatelessWidget {
  final BadgeProgress progress;

  const BadgeProgressDialog({
    super.key,
    required this.progress,
  });

  static void show(BuildContext context, BadgeProgress progress) {
    showDialog(
      context: context,
      builder: (context) => BadgeProgressDialog(progress: progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        UiTranslationService.translate(
          context,
          'badge_progress_title',
          null,
          false,
        ),
      ),
      content: BadgeDisplay(
        level: progress.currentLevel,
        showName: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            UiTranslationService.translate(
              context,
              'common_close',
              null,
              false,
            ),
          ),
        ),
      ],
    );
  }
}
