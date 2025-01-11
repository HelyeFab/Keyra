import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../domain/entities/subscription_enums.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../widgets/subscription_card.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = UiTranslations.of(context);

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text('Error: $message')),
          loaded: (subscription) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Features list
                ...List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xxs),
                          decoration: BoxDecoration(
                            color: AppColors.subscriptionHighlight.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.subscriptionHighlight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            translations.translate('premium_feature_${index + 1}'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  translations.translate('select_subscription'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Subscription cards
                SubscriptionCard(
                  title: translations.translate('premium_yearly'),
                  price: translations.translate('price_yearly'),
                  isPremium: true,
                  isCurrentPlan: subscription.tier == SubscriptionTier.premium && 
                                subscription.status == SubscriptionStatus.active,
                  features: const ['Best Value', '12 Months Access'],
                  onSubscribe: () => context.read<SubscriptionBloc>().add(
                        const SubscriptionEvent.upgraded(),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                SubscriptionCard(
                  title: translations.translate('premium_monthly'),
                  price: translations.translate('price_monthly'),
                  isPremium: false,
                  isCurrentPlan: false,
                  features: const ['Monthly Access'],
                  onSubscribe: () => context.read<SubscriptionBloc>().add(
                        const SubscriptionEvent.upgraded(),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                SubscriptionCard(
                  title: translations.translate('premium_lifetime'),
                  price: translations.translate('price_lifetime'),
                  isPremium: true,
                  isCurrentPlan: false,
                  features: const ['Lifetime Access', 'One-time Payment'],
                  onSubscribe: () => context.read<SubscriptionBloc>().add(
                        const SubscriptionEvent.upgraded(),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}
