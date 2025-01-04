import 'package:flutter/material.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/word_definition_modal.dart';

class TappableText extends StatelessWidget {
  final String text;
  final BookLanguage language;
  final TextStyle? style;
  final TextAlign textAlign;

  const TappableText({
    super.key,
    required this.text,
    required this.language,
    this.style,
    this.textAlign = TextAlign.left,
  });

  void _handleWordTap(BuildContext context, String word) {
    WordDefinitionModal.show(context, word.trim(), language);
  }

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium!;

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: words.asMap().entries.map((entry) {
          final word = entry.value;
          return WidgetSpan(
            child: GestureDetector(
              onTap: () => _handleWordTap(context, word),
              child: Text(
                word + (entry.key < words.length - 1 ? ' ' : ''),
                style: defaultStyle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                  decorationColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
