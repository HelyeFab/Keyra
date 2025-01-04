import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';

class AnimatedBadgeTooltip extends StatefulWidget {
  final Widget child;
  final String tooltip;
  final bool isVisible;
  final double badgeSize;

  const AnimatedBadgeTooltip({
    super.key,
    required this.child,
    required this.tooltip,
    required this.isVisible,
    required this.badgeSize,
  });

  @override
  State<AnimatedBadgeTooltip> createState() => _AnimatedBadgeTooltipState();
}

class _AnimatedBadgeTooltipState extends State<AnimatedBadgeTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: -20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(AnimatedBadgeTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.isVisible)
          Positioned(
            left: widget.badgeSize + 4,
            top: (widget.badgeSize - 28) / 2,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(_slideAnimation.value, 0),
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.tooltipBackground.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            widget.tooltip,
                            style: const TextStyle(
                              color: AppColors.controlText,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
