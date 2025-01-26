import 'package:flutter/material.dart';

class StudyPage extends StatelessWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Study'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Session'),
            ),
          ],
        ),
      ),
    );
  }
}
