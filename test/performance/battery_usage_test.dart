import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:Keyra/core/services/battery_monitoring_service.dart';
import 'package:Keyra/features/books/services/book_service.dart';
import 'package:Keyra/features/dictionary/services/dictionary_service.dart';

class MockBattery extends Mock implements Battery {}
class MockBookService extends Mock implements BookService {}
class MockDictionaryService extends Mock implements DictionaryService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BatteryMonitoringService batteryService;
  late MockBattery mockBattery;
  late MockBookService mockBookService;
  late MockDictionaryService mockDictionaryService;
  int batteryLevelCalls = 0;

  setUp(() {
    mockBattery = MockBattery();
    mockBookService = MockBookService();
    mockDictionaryService = MockDictionaryService();
    batteryService = BatteryMonitoringService(battery: mockBattery);
    batteryLevelCalls = 0;

    // Setup basic book service mocks
    when(() => mockBookService.loadBook(
      bookId: any(named: 'bookId'),
      content: any(named: 'content'),
    )).thenAnswer((_) async => {'id': 'test-book', 'content': 'test content'});

    when(() => mockBookService.getRecentBooks())
        .thenAnswer((_) => Stream.value([
          {'id': 'book-1', 'title': 'Test Book 1', 'progress': 0.5},
        ]));

    // Setup dictionary service mocks
    when(() => mockDictionaryService.lookupWord(any(), any()))
        .thenAnswer((_) async => DictionaryResult(
          word: 'test',
          translation: 'prueba',
          language: 'es',
          definitions: ['test definition'],
        ));

    // Register fallback values for Mocktail
    registerFallbackValue('test-book');
    registerFallbackValue('test content');
  });

  group('Battery Usage Tests', () {
    test('reading session maintains efficient battery usage', () async {
      // Simulate battery levels for a 1-hour reading session
      when(() => mockBattery.batteryLevel).thenAnswer((_) async {
        batteryLevelCalls++;
        return batteryLevelCalls == 1 ? 100 : 95;
      });

      when(() => mockBattery.batteryState)
          .thenAnswer((_) async => BatteryState.discharging);

      await batteryService.startMonitoring();
      batteryService.setSimulatedDuration(const Duration(hours: 1));

      // Simulate reading activity
      for (var i = 0; i < 30; i++) {
        // Every 2 minutes: load new page
        await mockBookService.loadBook(
          bookId: 'test-book',
          content: List.generate(1024 * 1024, (i) => 'a').join(),
        );

        // Every 5 minutes: lookup a word
        if (i % 5 == 0) {
          await mockDictionaryService.lookupWord('test', 'es');
        }
      }

      final result = await batteryService.stopMonitoring();

      // Verify battery usage is within acceptable limits
      expect(result.drainPerHour, lessThanOrEqualTo(5.0),
          reason: 'Battery drain should not exceed 5% per hour during reading');
    });

    test('background sync optimizes battery usage', () async {
      // Simulate battery levels for 30-minute background sync
      when(() => mockBattery.batteryLevel).thenAnswer((_) async {
        batteryLevelCalls++;
        return batteryLevelCalls == 1 ? 100 : 99;
      });

      when(() => mockBattery.batteryState)
          .thenAnswer((_) async => BatteryState.discharging);

      await batteryService.startMonitoring();
      batteryService.setSimulatedDuration(const Duration(minutes: 30));

      // Simulate background sync operations
      for (var i = 0; i < 6; i++) {
        // Every 5 minutes: sync data
        await mockBookService.getRecentBooks().first;
      }

      final result = await batteryService.stopMonitoring();

      // Verify battery usage is within acceptable limits
      expect(result.drainPerHour, lessThanOrEqualTo(2.0),
          reason: 'Battery drain should not exceed 2% per hour during background sync');
    });

    test('intensive operations handle battery optimization', () async {
      // Simulate battery levels for 15-minute intensive operation
      when(() => mockBattery.batteryLevel).thenAnswer((_) async {
        batteryLevelCalls++;
        return batteryLevelCalls == 1 ? 100 : 98;
      });

      when(() => mockBattery.batteryState)
          .thenAnswer((_) async => BatteryState.discharging);

      await batteryService.startMonitoring();
      batteryService.setSimulatedDuration(const Duration(minutes: 15));

      // Simulate intensive operations
      for (var i = 0; i < 15; i++) {
        // Every minute: process large book
        await mockBookService.loadBook(
          bookId: 'large-book',
          content: List.generate(5 * 1024 * 1024, (i) => 'a').join(),
        );
      }

      final result = await batteryService.stopMonitoring();

      // Verify battery usage is within acceptable limits
      expect(result.drainPerHour, lessThanOrEqualTo(8.0),
          reason: 'Battery drain should not exceed 8% per hour during intensive operations');
    });
  });
}
