import 'package:flutter/material.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/jisho_meanings_widget.dart';

/// This class uses the builder pattern to inject additional content
/// into the Japanese modal without modifying the original modal
class JapaneseModalContentBuilder {
  /// Injects Jisho meanings into the existing modal content
  /// 
  /// [context] The build context
  /// [child] The original modal content
  /// [word] The word to look up
  /// [theme] The current theme
  static Widget injectJishoMeanings(
    BuildContext context,
    Widget child,
    String word,
    ThemeData theme,
  ) {
    // Use a LayoutBuilder to get the available space
    return LayoutBuilder(
      builder: (context, constraints) {
        const double contentPadding = 16.0;
        final double jishoSectionOffset = constraints.maxHeight * 0.5;

        return Stack(
          children: [
            child,
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Original content will be pushed up by the SizedBox
                    SizedBox(height: jishoSectionOffset),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: contentPadding),
                      child: JishoMeaningsWidget(
                        word: word,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: 16), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
