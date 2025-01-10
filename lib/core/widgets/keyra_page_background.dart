import 'package:flutter/material.dart';

class KeyraPageBackground extends StatelessWidget {
  final Widget child;
  final String page;

  const KeyraPageBackground({
    super.key,
    required this.child,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: child,
    );
  }
}
