import 'package:flutter/material.dart';

class SocialSignInButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;

  const SocialSignInButtons({
    super.key,
    required this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onGooglePressed,
          icon: const Icon(Icons.g_mobiledata),
          tooltip: 'Sign in with Google',
        ),
      ],
    );
  }
}
