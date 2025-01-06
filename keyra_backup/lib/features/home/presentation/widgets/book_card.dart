import 'package:flutter/material.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String coverImagePath;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.coverImagePath,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    coverImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading cover image: $error');
                      return const Center(child: Icon(Icons.error));
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const LoadingAnimation(size: 50);
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: onFavoriteTap,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
