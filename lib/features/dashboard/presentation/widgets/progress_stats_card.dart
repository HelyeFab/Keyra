import 'package:flutter/material.dart';

class ProgressStatsCard extends StatelessWidget {
  final String title;
  final int value;
  final int maxValue;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ProgressStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the current level and progress within that level
    final int currentLevel = (value / maxValue).ceil();
    final int progressInCurrentLevel = value % maxValue;
    final double progressValue = progressInCurrentLevel == 0 ? 1.0 : progressInCurrentLevel / maxValue;
    
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (currentLevel > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Level $currentLevel',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Value display with achievement indicator
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (value >= maxValue)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(
                        Icons.stars,
                        size: 20,
                        color: color,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Progress bar
              Stack(
                children: [
                  // Background for all levels
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.2)),
                      minHeight: 8,
                    ),
                  ),
                  // Current level progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              
              // Progress text
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value >= maxValue
                          ? '${progressInCurrentLevel == 0 ? maxValue : progressInCurrentLevel} / $maxValue in current level'
                          : '$value / $maxValue',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (value >= maxValue)
                      Text(
                        'Target Achieved!',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
