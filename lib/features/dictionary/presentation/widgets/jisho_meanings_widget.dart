import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/features/dictionary/presentation/bloc/jisho_meanings_bloc.dart';

@immutable
class JishoMeaningsWidget extends StatefulWidget {
  final String word;
  final ThemeData theme;

  const JishoMeaningsWidget({
    super.key,
    required this.word,
    required this.theme,
  });

  @override
  State<JishoMeaningsWidget> createState() => _JishoMeaningsWidgetState();
}

class _JishoMeaningsWidgetState extends State<JishoMeaningsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<JishoMeaningsBloc>().add(LoadJishoMeanings(widget.word));
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JishoMeaningsBloc, JishoMeaningsState>(
      builder: (context, state) {
        if (state is JishoMeaningsLoading) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state is JishoMeaningsError) {
          return const SizedBox.shrink(); // Hide on error to not disrupt the modal
        }

        if (state is JishoMeaningsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Additional Meanings (Jisho)',
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      color: widget.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.translate,
                    size: 16,
                    color: widget.theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._buildMeanings(state.meanings),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildMeanings(Map<String, dynamic> meanings) {
    final List<dynamic> meaningsList = meanings['meanings'] as List<dynamic>? ?? [];
    
    return meaningsList.map<Widget>((meaning) {
      final isPrimary = meaning['primary'] as bool? ?? false;
      final meaningText = meaning['meaning'] as String? ?? 'No meaning available';
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• '),
            Expanded(
              child: Text(
                meaningText,
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
