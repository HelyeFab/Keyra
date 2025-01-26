import 'package:flutter/material.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/widgets/loading_indicator.dart';
import 'package:Keyra/features/books/data/services/book_cover_cache_manager.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String coverImagePath;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;
  final String? category;
  final int? totalPages;

  const BookCard({
    super.key,
    required this.title,
    required this.coverImagePath,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    this.category,
    this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusMd),
                      topRight: Radius.circular(AppSpacing.radiusMd),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: BookCoverCacheManager.instance,
                      imageUrl: coverImagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: LoadingIndicator(size: 30),
                        ),
                      ),
                      memCacheWidth: 480,
                      memCacheHeight: 480,
                      errorWidget: (context, url, error) {
                        Logger.error('Failed to load cover image', error: error);
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFavoriteTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (category != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        category!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  if (totalPages != null) ...[
                    const SizedBox(height: 2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$totalPages ${UiTranslations.of(context).translate('pages')}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
