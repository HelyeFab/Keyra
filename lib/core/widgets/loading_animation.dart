import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;

  const LoadingAnimation({
    super.key,
    this.size = 100, // Default size that can be overridden
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loader/animation_1734447560170.json',
        width: size,
        height: size,
      ),
    );
  }
}
