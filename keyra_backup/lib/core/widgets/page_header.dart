import 'package:flutter/material.dart';
import '../../features/badges/presentation/widgets/badge_display.dart';
import '../../features/badges/domain/models/badge_level.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBadge;
  final double horizontalPadding;

  const PageHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBadge = true,
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (showBadge) ...[
            const BadgeDisplay(
              level: BadgeLevel.beginner,
            ),
            const SizedBox(width: 8),
          ],
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
