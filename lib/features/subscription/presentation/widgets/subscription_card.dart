import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String? storePrice;
  final List<String> features;
  final VoidCallback onSubscribe;
  final bool isCurrentPlan;
  final bool isPremium;
  final bool isAvailable;

  const SubscriptionCard({
    super.key,
    required this.title,
    this.storePrice,
    required this.features,
    required this.onSubscribe,
    this.isCurrentPlan = false,
    this.isPremium = false,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    final translations = UiTranslations.of(context);
    const cardColor = AppColors.subscriptionCardLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isPremium ? AppColors.subscriptionBorder : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCurrentPlan ? null : onSubscribe,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (isPremium) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.subscriptionStar,
                            size: AppSpacing.badgeSize,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.subscriptionText,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (storePrice != null)
                      Text(
                        storePrice!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.subscriptionText,
                            ),
                      )
                    else
                      Text(
                        isAvailable 
                            ? translations.translate('loading')
                            : translations.translate('not_available'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.subscriptionText,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    ...features.map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.subscriptionSubtext,
                                ),
                          ),
                        )),
                    if (isCurrentPlan)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          'Current Plan',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.subscriptionHighlight,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isPremium && title.contains('12'))
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.subscriptionHighlight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: Text(
                      translations.translate('best_value'),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
