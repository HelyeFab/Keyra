import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../domain/entities/subscription_enums.dart';
import '../../data/services/purchase_handler.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../bloc/purchase_bloc.dart';
import '../bloc/purchase_state.dart';
import '../bloc/purchase_event.dart';
import '../widgets/subscription_card.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = UiTranslations.of(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PurchaseHandler>(
          create: (context) => PurchaseHandler(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PurchaseBloc>(
            create: (context) => PurchaseBloc(
              purchaseHandler: context.read<PurchaseHandler>(),
            )..add(const PurchaseEvent.started()),
          ),
        ],
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
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
                          child: const Icon(
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
                                  color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Subscription cards
                BlocBuilder<PurchaseBloc, PurchaseState>(
                  builder: (context, purchaseState) {
                    if (!purchaseState.isAvailable) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            translations.translate('store_not_available'),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        if (purchaseState.yearlyProduct != null)
                          SubscriptionCard(
                            title: translations.translate('premium_yearly'),
                            storePrice: purchaseState.yearlyProduct?.price,
                            isPremium: true,
                            isCurrentPlan: subscription.tier == SubscriptionTier.premium && 
                                        subscription.status == SubscriptionStatus.active,
                            features: [translations.translate('best_value'), translations.translate('yearly_access')],
                            onSubscribe: () => context.read<SubscriptionBloc>().add(
                                  const SubscriptionEvent.upgraded(),
                                ),
                            isAvailable: true,
                          ),
                        if (purchaseState.yearlyProduct != null)
                          const SizedBox(height: AppSpacing.md),
                        if (purchaseState.monthlyProduct != null)
                          SubscriptionCard(
                            title: translations.translate('premium_monthly'),
                            storePrice: purchaseState.monthlyProduct?.price,
                            isPremium: false,
                            isCurrentPlan: false,
                            features: [translations.translate('monthly_access')],
                            onSubscribe: () => context.read<SubscriptionBloc>().add(
                                  const SubscriptionEvent.upgraded(),
                                ),
                            isAvailable: true,
                          ),
                        if (purchaseState.monthlyProduct != null)
                          const SizedBox(height: AppSpacing.md),
                        if (purchaseState.lifetimeProduct != null)
                          SubscriptionCard(
                            title: translations.translate('premium_lifetime'),
                            storePrice: purchaseState.lifetimeProduct?.price,
                            isPremium: true,
                            isCurrentPlan: false,
                            features: [translations.translate('lifetime_access'), translations.translate('one_time_payment')],
                            onSubscribe: () => context.read<SubscriptionBloc>().add(
                                  const SubscriptionEvent.upgraded(),
                                ),
                            isAvailable: true,
                          ),
                        if (purchaseState.products.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Text(
                              translations.translate('no_products_available'),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Restore purchases button
                TextButton(
                  onPressed: () => context.read<SubscriptionBloc>().add(
                        const SubscriptionEvent.restored(),
                      ),
                  child: Text(
                    translations.translate('restore_purchases'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
        },
      ),
    ));
  }
}
