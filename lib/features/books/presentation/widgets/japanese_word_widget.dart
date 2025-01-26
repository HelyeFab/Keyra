import 'package:flutter/material.dart';
import 'package:Keyra/core/theme/color_schemes.dart';

class JapaneseWordWidget extends StatelessWidget {
  final String word;
  final String? reading;
  final TextStyle baseStyle;
  final VoidCallback? onTap;

  const JapaneseWordWidget({
    super.key,
    required this.word,
    this.reading,
    required this.baseStyle,
    this.onTap,
  });

  bool _isKanji(String char) {
    final int code = char.characters.first.codeUnitAt(0);
    return code >= 0x4E00 && code <= 0x9FFF;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final furiganaSize = screenWidth * 0.028; // 2.8% of screen width
    final furiganaSpacing = screenWidth * 0.008; // 0.8% of screen width
    final characterSpacing = screenWidth * 0.002; // 0.2% of screen width

    // Calculate widths to ensure proper alignment
    final textPainter = TextPainter(
      text: TextSpan(text: word, style: baseStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final wordWidth = textPainter.width;

    TextPainter? rubyPainter;
    if (reading != null) {
      rubyPainter = TextPainter(
        text: TextSpan(
          text: reading,
          style: baseStyle.copyWith(
            fontSize: furiganaSize,
            height: 1.0,
            color: AppColors.darkPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }
    final rubyWidth = rubyPainter?.width ?? 0;
    final maxWidth = rubyWidth > wordWidth ? rubyWidth : wordWidth;

    // Group consecutive kanji characters
    final List<({String text, bool isKanji})> groups = [];
    String currentGroup = '';
    bool currentIsKanji = false;

    for (final char in word.characters) {
      final isKanji = _isKanji(char);
      if (currentGroup.isEmpty || currentIsKanji == isKanji) {
        currentGroup += char;
      } else {
        groups.add((text: currentGroup, isKanji: currentIsKanji));
        currentGroup = char;
      }
      currentIsKanji = isKanji;
    }
    if (currentGroup.isNotEmpty) {
      groups.add((text: currentGroup, isKanji: currentIsKanji));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: maxWidth + (characterSpacing * 2),
        padding: EdgeInsets.symmetric(horizontal: characterSpacing),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: groups.map((group) {
              final groupTextPainter = TextPainter(
                text: TextSpan(text: group.text, style: baseStyle),
                textDirection: TextDirection.ltr,
              )..layout();

              return SizedBox(
                width: groupTextPainter.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (reading != null && group.isKanji)
                      SizedBox(
                        height: furiganaSize * 1.5,
                        child: Text(
                          reading!,
                          style: baseStyle.copyWith(
                            fontSize: furiganaSize,
                            height: 1.0,
                            color: AppColors.darkPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      SizedBox(height: furiganaSize * 1.5),
                    SizedBox(height: furiganaSpacing),
                    Text(
                      group.text,
                      style: baseStyle.copyWith(height: 1.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
