import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/onboarding_data.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24.0).copyWith(
          bottom: MediaQuery.of(context).padding.bottom + 140, // Extra padding for button area
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                image: DecorationImage(
                  image: AssetImage(data.imagePath),
                  fit: BoxFit.contain,
                ),
                boxShadow: AppSpacing.shadowMd(Theme.of(context).shadowColor),
              ),
              clipBehavior: Clip.antiAlias,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Text(
              data.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              data.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
