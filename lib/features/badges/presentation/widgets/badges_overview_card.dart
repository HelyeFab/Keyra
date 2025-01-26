import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../domain/models/badge_level.dart';
import '../../domain/models/badge_requirements.dart';
import '../bloc/badge_bloc.dart';
import '../bloc/badge_state.dart';
import 'badge_display.dart';

class BadgesOverviewCard extends StatelessWidget {
  const BadgesOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  UiTranslationService.translate(context, 'achievements'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.sectionTitle,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<BadgeBloc, BadgeState>(
              builder: (context, state) {
                return Column(
                  children: BadgeLevel.values.map((level) {
                    final requirements = BadgeRequirements.getRequirementsForLevel(level);
                    final isCurrentLevel = state.map(
                      initial: (_) => false,
                      loaded: (loaded) => loaded.progress.currentLevel == level,
                      levelingUp: (levelingUp) => levelingUp.progress.currentLevel == level,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrentLevel 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withOpacity(0.3),
                          width: isCurrentLevel ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BadgeDisplay(
                            level: level,
                            showName: true,
                            displayName: UiTranslationService.translate(
                              context,
                              requirements.displayName,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Requirements section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                UiTranslationService.translate(context, 'requirements'),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              _buildRequirement(
                                context,
                                Icons.book,
                                UiTranslationService.translate(
                                  context, 
                                'books_read_requirement',
                                [requirements.requiredBooksRead.toString()],
                                ),
                              ),
                              _buildRequirement(
                                context,
                                Icons.favorite,
                                UiTranslationService.translate(
                                  context, 
                                'favorite_books_requirement',
                                [requirements.requiredFavoriteBooks.toString()],
                                ),
                              ),
                              _buildRequirement(
                                context,
                                Icons.local_fire_department,
                                UiTranslationService.translate(
                                  context, 
                                'reading_streak_requirement',
                                [requirements.requiredReadingStreak.toString()],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
