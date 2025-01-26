import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final String bookId;

  const BookDetailsPage({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Book ID: $bookId'),
          const SizedBox(height: 16),
          const Text('Chapter 1'),
        ],
      ),
    );
  }
}
