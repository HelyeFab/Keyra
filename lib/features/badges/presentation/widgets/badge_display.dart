import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/models/badge_level.dart';
import 'animated_badge_tooltip.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';

class BadgeDisplay extends StatefulWidget {
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
  State<BadgeDisplay> createState() => _BadgeDisplayState();
}

class _BadgeDisplayState extends State<BadgeDisplay> {
  bool _showTooltip = false;
  Timer? _tooltipTimer;

  void _showTooltipTemporarily() {
    setState(() {
      _showTooltip = true;
    });

    // Cancel any existing timer
    _tooltipTimer?.cancel();

    // Start a new timer to hide the tooltip after 2 seconds
    _tooltipTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTooltip = false;
        });
      }
    });
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _tooltipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBadgeTooltip(
      tooltip: UiTranslations.of(context).translate(widget.level.displayName),
      isVisible: _showTooltip,
      badgeSize: BadgeDisplay.badgeSize,
      child: GestureDetector(
        onTap: _showTooltipTemporarily,
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
                widget.level.assetPath,
                width: BadgeDisplay.badgeSize,
                height: BadgeDisplay.badgeSize,
                fit: BoxFit.contain,
              ),
            ),
            if (widget.showName) ...[
              const SizedBox(width: 8),
              Text(
                widget.displayName ?? '',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
