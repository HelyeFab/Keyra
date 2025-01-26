import 'package:flutter/material.dart';
import '../../domain/models/badge_level.dart';


class BadgeDisplay extends StatelessWidget {
  final BadgeLevel level;
  final bool showName;
  final VoidCallback? onTap;
  final String? displayName;
  static const double badgeSize = 36.0;

  const BadgeDisplay({
    super.key,
    required this.level,
    this.showName = false,
    this.onTap,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Image.asset(
              level.assetPath,
              width: BadgeDisplay.badgeSize,
              height: BadgeDisplay.badgeSize,
              fit: BoxFit.contain,
            ),
          ),
          if (showName) ...[
            const SizedBox(width: 8),
            Text(
              displayName ?? '',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
