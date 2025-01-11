import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/subscription_enums.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_state.dart';

class SubscriptionBadge extends StatelessWidget {
  const SubscriptionBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (subscription) {
            final bool isPremium = subscription.tier == SubscriptionTier.premium && 
                                 subscription.status == SubscriptionStatus.active;
            final String assetPath = isPremium
                ? 'assets/subscription/premium.png'
                : 'assets/subscription/free.png';
            final String displayText = isPremium ? 'Premium' : 'Free';

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    assetPath,
                    width: AppSpacing.badgeSize,
                    height: AppSpacing.badgeSize,
                    fit: BoxFit.contain,
                  ),
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
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
