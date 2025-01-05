import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hugeicons/hugeicons.dart';
import '../ui_language/service/ui_translation_service.dart';


class AnimatedNavItem extends StatefulWidget {
  final Widget icon;
  final Widget activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<AnimatedNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: widget.isSelected ? widget.activeIcon : widget.icon,
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: widget.isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurface,
                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KeyraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AnimatedNavItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome13,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24.0,
                ),
                activeIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedHome13,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.0,
                ),
                label: UiTranslationService.translate(context, 'nav_home'),
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              AnimatedNavItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedLibrary,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24.0,
                ),
                activeIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedLibrary,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.0,
                ),
                label: UiTranslationService.translate(context, 'nav_library'),
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              AnimatedNavItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedMortarboard02,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24.0,
                ),
                activeIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedMortarboard02,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.0,
                ),
                label: UiTranslationService.translate(context, 'nav_study'),
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              AnimatedNavItem(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedAnalyticsUp,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24.0,
                ),
                activeIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedAnalyticsUp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28.0,
                ),
                label: UiTranslationService.translate(context, 'nav_dashboard'),
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
