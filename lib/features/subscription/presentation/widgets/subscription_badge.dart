import 'package:flutter/material.dart';

class SubscriptionBadge extends StatelessWidget {
  final String tier;
  static const double badgeSize = 24.0;

  const SubscriptionBadge({
    super.key,
    required this.tier,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPremium = tier.toLowerCase() == 'premium';
    final String assetPath = isPremium
        ? 'assets/subscription/premium.png'
        : 'assets/subscription/free.png';
    final String displayText = isPremium ? 'Premium User' : 'Free User';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          width: badgeSize,
          height: badgeSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 4),
        Text(
          displayText,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
