import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Keyra/core/theme/app_spacing.dart';
import 'package:Keyra/core/widgets/loading_indicator.dart';
import 'package:Keyra/features/books/data/services/book_cover_cache_manager.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String coverImagePath;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.coverImagePath,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.75, // Standard book cover ratio
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusMd),
                      topRight: Radius.circular(AppSpacing.radiusMd),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: BookCoverCacheManager.instance,
                      imageUrl: coverImagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: LoadingIndicator(size: 30),
                        ),
                      ),
                      memCacheWidth: 360, // 2x the display width for quality
                      memCacheHeight: 320, // 2x the display height for quality
                      errorWidget: (context, url, error) {
                        print('Error loading cover image: $error');
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined, size: 40),
                          ),
                        );
                      },
                    ),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Space reserved for future additions:
                  // - Reading time
                  // - Genre
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}