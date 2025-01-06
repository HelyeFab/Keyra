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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusMd),
                    topRight: Radius.circular(AppSpacing.radiusMd),
                  ),
                  child: CachedNetworkImage(
                    cacheManager: BookCoverCacheManager.instance,
                    imageUrl: coverImagePath,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: LoadingIndicator(size: 30),
                    ),
                    errorWidget: (context, url, error) {
                      print('Error loading cover image: $error');
                      return Container(
                        height: 160,
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
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
