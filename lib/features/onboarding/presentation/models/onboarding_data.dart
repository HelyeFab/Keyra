import 'package:flutter/material.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  bool isFavorite;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  OnboardingData copyWith({
    String? title,
    String? description,
    String? imagePath,
    bool? isFavorite,
  }) {
    return OnboardingData(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

List<OnboardingData> getOnboardingPages(BuildContext context) {
  return [
    OnboardingData(
      title: UiTranslations.of(context).translate('onboarding_welcome'),
      description: UiTranslations.of(context).translate('onboarding_description'),
      imagePath: 'assets/images/onboarding/keyra01.png',
    ),
    OnboardingData(
      title: UiTranslations.of(context).translate('onboarding_feature_1_title'),
      description: UiTranslations.of(context).translate('onboarding_feature_1_desc'),
      imagePath: 'assets/images/onboarding/keyra02.png',
    ),
    OnboardingData(
      title: UiTranslations.of(context).translate('onboarding_feature_2_title'),
      description: UiTranslations.of(context).translate('onboarding_feature_2_desc'),
      imagePath: 'assets/images/onboarding/keyra03.png',
    ),
    OnboardingData(
      title: UiTranslations.of(context).translate('onboarding_feature_3_title'),
      description: UiTranslations.of(context).translate('onboarding_feature_3_desc'),
      imagePath: 'assets/images/onboarding/keyra04.png',
    ),
  ];
}
