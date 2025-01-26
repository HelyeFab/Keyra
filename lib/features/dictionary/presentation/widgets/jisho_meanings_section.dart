import 'package:flutter/material.dart';

class JishoMeaningsSection extends StatelessWidget {
  final ThemeData theme;
  final Map<String, dynamic>? jishoData;

  const JishoMeaningsSection({
    super.key,
    required this.theme,
    required this.jishoData,
  });

  @override
  Widget build(BuildContext context) {
    if (jishoData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Jisho Meanings',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.language,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._buildMeanings(),
      ],
    );
  }

  List<Widget> _buildMeanings() {
    final meanings = jishoData?['meanings'] as List<dynamic>?;
    if (meanings == null || meanings.isEmpty) return [];

    return meanings.map<Widget>((meaning) {
      final isPrimary = meaning['primary'] as bool? ?? false;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• '),
            Expanded(
              child: Text(
                meaning['meaning'] as String? ?? '',
                style: isPrimary
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
