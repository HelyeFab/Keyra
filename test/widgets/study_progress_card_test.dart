import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:Keyra/features/study/services/study_service.dart';
import 'package:Keyra/features/study/widgets/study_progress_card.dart';

class MockStudyService extends Mock implements StudyService {}

void main() {
  late MockStudyService mockStudyService;

  setUp(() {
    mockStudyService = MockStudyService();
  });

  testWidgets('StudyProgressCard displays loading state', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Future.delayed(
        const Duration(seconds: 1),
        () => Right(StudyStats(
          totalSessions: 10,
          totalWordsReviewed: 100,
          averageAccuracy: 0.8,
        )),
      ),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('StudyProgressCard displays study stats', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Right(StudyStats(
        totalSessions: 10,
        totalWordsReviewed: 100,
        averageAccuracy: 0.8,
      )),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );
    await tester.pump();

    // Assert
    expect(find.text('10'), findsOneWidget); // Total sessions
    expect(find.text('100'), findsOneWidget); // Words reviewed
    expect(find.text('80%'), findsOneWidget); // Accuracy percentage
  });

  testWidgets('StudyProgressCard displays error state', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Left(StudyFailure(
        code: 'error',
        message: 'Failed to load stats',
      )),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );
    await tester.pump();

    // Assert
    expect(find.text('Failed to load stats'), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('StudyProgressCard handles refresh', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Right(StudyStats(
        totalSessions: 10,
        totalWordsReviewed: 100,
        averageAccuracy: 0.8,
      )),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );
    await tester.pump();

    // Find and tap refresh button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Assert
    verify(() => mockStudyService.getStudyStats()).called(2); // Initial + refresh
  });

  testWidgets('StudyProgressCard animates progress changes', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Right(StudyStats(
        totalSessions: 10,
        totalWordsReviewed: 100,
        averageAccuracy: 0.8,
      )),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );

    // Initial build
    await tester.pump();
    
    // Verify initial animation state
    final initialProgressFinder = find.byType(AnimatedProgressIndicator);
    expect(initialProgressFinder, findsOneWidget);
    
    // Update stats
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Right(StudyStats(
        totalSessions: 15,
        totalWordsReviewed: 150,
        averageAccuracy: 0.85,
      )),
    );

    // Trigger refresh
    await tester.tap(find.byIcon(Icons.refresh));
    
    // Start animation
    await tester.pump();
    
    // Run animation
    await tester.pump(const Duration(milliseconds: 500));
    
    // Verify animation completed
    expect(find.text('15'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
  });

  testWidgets('StudyProgressCard handles zero stats gracefully', (tester) async {
    // Arrange
    when(() => mockStudyService.getStudyStats()).thenAnswer(
      (_) async => Right(StudyStats(
        totalSessions: 0,
        totalWordsReviewed: 0,
        averageAccuracy: 0.0,
      )),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudyProgressCard(
            studyService: mockStudyService,
          ),
        ),
      ),
    );
    await tester.pump();

    // Assert
    expect(find.text('0'), findsNWidgets(2)); // Sessions and words
    expect(find.text('0%'), findsOneWidget); // Accuracy
    expect(find.text('No study sessions yet'), findsOneWidget);
  });
}
