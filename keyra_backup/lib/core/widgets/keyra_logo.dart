import 'package:flutter/material.dart';

class KeyraLogo extends StatelessWidget {
  final double height;

  const KeyraLogo({
    super.key,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/onboarding/logo.png',
          height: height * 0.7, // Make the image slightly smaller than container
          width: height * 0.7,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('KeyraLogo Error: $error');
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
