import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import '../services/study_service.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final double value;
  final Duration duration;

  const AnimatedProgressIndicator({
    Key? key,
    required this.value,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      builder: (context, value, child) {
        return CircularProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }
}

class StudyProgressCard extends StatefulWidget {
  final StudyService studyService;

  const StudyProgressCard({
    Key? key,
    required this.studyService,
  }) : super(key: key);

  @override
  State<StudyProgressCard> createState() => _StudyProgressCardState();
}

class _StudyProgressCardState extends State<StudyProgressCard> {
  late Future<dartz.Either<StudyFailure, StudyStats>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    _statsFuture = widget.studyService.getStudyStats();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Study Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadStats,
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<dartz.Either<StudyFailure, StudyStats>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorState('An unexpected error occurred');
                }

                if (!snapshot.hasData) {
                  return _buildErrorState('No data available');
                }

                return snapshot.data!.fold(
                  (failure) => _buildErrorState(failure.message),
                  (stats) => _buildStats(stats),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(StudyStats stats) {
    if (stats.totalSessions == 0) {
      return const Center(
        child: Text(
          'No study sessions yet',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          'Sessions',
          stats.totalSessions.toString(),
          stats.totalSessions / 100,
        ),
        _buildStatItem(
          'Words',
          stats.totalWordsReviewed.toString(),
          stats.totalWordsReviewed / 1000,
        ),
        _buildStatItem(
          'Accuracy',
          '${(stats.averageAccuracy * 100).round()}%',
          stats.averageAccuracy,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, double progress) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: AnimatedProgressIndicator(value: progress.clamp(0.0, 1.0)),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
