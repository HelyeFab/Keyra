import 'package:flutter/material.dart';
import '../../domain/models/badge_level.dart';
import '../widgets/badge_display.dart';

class BadgeTestPage extends StatefulWidget {
  const BadgeTestPage({super.key});

  @override
  State<BadgeTestPage> createState() => _BadgeTestPageState();
}

class _BadgeTestPageState extends State<BadgeTestPage> {
  BadgeLevel currentLevel = BadgeLevel.beginner;

  void _cycleLevel() {
    setState(() {
      currentLevel = BadgeLevel.values[
          (BadgeLevel.values.indexOf(currentLevel) + 1) % BadgeLevel.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BadgeDisplay(
          level: currentLevel,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Current Badge: ${currentLevel.displayName}'),
                content: BadgeDisplay(
                  level: currentLevel,
                  showName: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
        title: const Text('Badge Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Level: ${currentLevel.displayName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            BadgeDisplay(
              level: currentLevel,
              showName: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cycleLevel,
              child: const Text('Cycle Badge Level'),
            ),
          ],
        ),
      ),
    );
  }
}
