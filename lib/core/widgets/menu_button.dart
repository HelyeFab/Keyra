import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MenuButton extends StatelessWidget {
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.size,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedUserList,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
        size: size,
      ),
    );
  }
}
