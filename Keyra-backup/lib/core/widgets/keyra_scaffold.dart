import 'package:flutter/material.dart';
import 'keyra_bottom_nav_bar.dart';

class KeyraScaffold extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final Widget child;

  const KeyraScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavigationChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.surface,
        ),
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            bottom: false,
            child: child,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: KeyraBottomNavBar(
                currentIndex: currentIndex,
                onTap: onNavigationChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
