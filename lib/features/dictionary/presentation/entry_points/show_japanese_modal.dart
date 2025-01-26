import 'package:flutter/material.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/features/dictionary/presentation/widgets/enhanced_japanese_modal_content.dart';

/// This function serves as the new entry point for showing the Japanese modal
/// It ensures the modal is wrapped with the necessary providers and includes Jisho meanings
Future<void> showJapaneseModal(
  BuildContext context,
  String word,
  BookLanguage language,
) {
  return EnhancedJapaneseModalContent.show(
    context,
    word,
    language,
  );
}
