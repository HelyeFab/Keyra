import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Keyra/features/profile/presentation/pages/profile_page.dart';

class MenuButton extends StatelessWidget {
  final double size;

  const MenuButton({
    super.key,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Lottie.asset(
          'assets/loader/animation_1734447560170.json',
          width: size * 0.6,
          height: size * 0.6,
        ),
      ),
    );
  }
}
