import 'package:flutter/material.dart';
import 'package:Keyra/core/widgets/loading_animation.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  
  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LoadingAnimation(
        size: size * 0.6, // Make the animation slightly smaller than the container
      ),
    );
  }
}
