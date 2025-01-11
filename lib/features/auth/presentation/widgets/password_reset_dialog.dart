import 'package:flutter/material.dart';

class PasswordResetDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? iconColor;

  const PasswordResetDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.iconColor,
  });

  static void showEmailRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PasswordResetDialog(
        title: 'Email Required',
        message: 'Please enter your email address to reset your password.',
        icon: Icons.email_outlined,
      ),
    );
  }

  static void showResetEmailSent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PasswordResetDialog(
        title: 'Reset Email Sent',
        message: 'A password reset link has been sent to your email address. Please check your inbox.',
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor ?? theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
