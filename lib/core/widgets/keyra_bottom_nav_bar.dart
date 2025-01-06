import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_spacing.dart';
import 'menu_button.dart';

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final curveWidth = 85.0;
    final curveHeight = 8.0;
    final cornerRadius = 10.0;
    
    path.moveTo(0, cornerRadius);
    
    // Top left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    
    // Line to start of curve
    path.lineTo(centerX - curveWidth, 0);
    
    // Gentle curve up with smoother transition
    path.cubicTo(
      centerX - curveWidth/3, 0,         // First control point
      centerX - curveWidth/6, -curveHeight,  // Second control point
      centerX, -curveHeight,              // First end point
    );
    
    path.cubicTo(
      centerX + curveWidth/6, -curveHeight,  // First control point
      centerX + curveWidth/3, 0,         // Second control point
      centerX + curveWidth, 0,           // Final end point
    );
    
    // Line to top right corner
    path.lineTo(size.width - cornerRadius, 0);
    
    // Top right corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    
    // Right side
    path.lineTo(size.width, size.height - cornerRadius);
    
    // Bottom right corner
    path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height);
    
    // Bottom side
    path.lineTo(cornerRadius, size.height);
    
    // Bottom left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
    final items = [
      _NavItem(icon: HugeIcons.strokeRoundedHome13, index: 0),
      _NavItem(icon: HugeIcons.strokeRoundedLibrary, index: 1),
      _NavItem(icon: HugeIcons.strokeRoundedMortarboard02, index: 2),
      _NavItem(icon: HugeIcons.strokeRoundedAnalyticsUp, index: 3),
      _NavItem(icon: HugeIcons.strokeRoundedUserList, index: 4, isMenuButton: true),
    ];

    return ClipPath(
      clipper: NavBarClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) => _buildNavItem(item, context)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, BuildContext context) {
    if (item.isMenuButton) {
      final isSelected = item.index == currentIndex;
      return SizedBox(
        width: 55,
        child: Center(
          child: MenuButton(
            size: isSelected ? AppSpacing.xl : AppSpacing.lg,
            isSelected: isSelected,
            onTap: () => onTap(item.index),
          ),
        ),
      );
    }

    final isSelected = item.index == currentIndex;
    return SizedBox(
      width: 55,
      child: Center(
        child: GestureDetector(
          onTap: () => onTap(item.index),
          behavior: HitTestBehavior.translucent,
          child: HugeIcon(
            icon: item.icon,
            size: isSelected ? AppSpacing.xl : AppSpacing.lg,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;
  final bool isMenuButton;

  const _NavItem({
    required this.icon,
    required this.index,
    this.isMenuButton = false,
  });
}
