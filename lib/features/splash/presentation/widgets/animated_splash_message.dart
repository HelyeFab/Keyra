import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedSplashMessage extends StatefulWidget {
  const AnimatedSplashMessage({super.key});

  @override
  State<AnimatedSplashMessage> createState() => _AnimatedSplashMessageState();
}

class _AnimatedSplashMessageState extends State<AnimatedSplashMessage> {
  final List<String> _messages = [
    "Your journey to mastering languages starts here",
    "Building your personalized bookshelf...",
    "Preparing your limited edition books...",
    "Downloading language dictionaries...",
    "Creating your learning adventure...",
  ];

  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _startMessageAnimation();
  }

  void _startMessageAnimation() {
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        _messages[_currentMessageIndex],
        key: ValueKey<int>(_currentMessageIndex),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
