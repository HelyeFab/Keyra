import 'package:flutter/material.dart';

class ChapterPage extends StatelessWidget {
  final String bookId;
  final String chapterId;

  const ChapterPage({
    Key? key,
    required this.bookId,
    required this.chapterId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Book ID: $bookId'),
            const SizedBox(height: 8),
            Text('Chapter ID: $chapterId'),
            const SizedBox(height: 16),
            const Text('Chapter 1 Content'),
          ],
        ),
      ),
    );
  }
}
