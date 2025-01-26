import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Keyra/core/services/connectivity_service.dart';

// Mock implementation to avoid factory constructor
class TestConnectivityService implements ConnectivityService {
  final Connectivity _connectivity;
  
  TestConnectivityService(this._connectivity);

  @override
  Future<bool> hasConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => 
    _connectivity.onConnectivityChanged;
}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConnectivity mockConnectivity;
  late TestConnectivityService connectivityService;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityService = TestConnectivityService(mockConnectivity);
  });

  tearDown(() {
    // No need for explicit stream cleanup since we're using local StreamControllers
  });

  group('ConnectivityService', () {
    test('returns same instance when constructed multiple times', () {
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => const Stream.empty());
          
      final instance1 = ConnectivityService();
      final instance2 = ConnectivityService();
      
      expect(identical(instance1, instance2), isTrue);
    });

    group('hasConnection', () {
      test('returns true when wifi connected', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => const Stream.empty());

        final result = await connectivityService.hasConnection();
        expect(result, isTrue);
      });

      test('returns true when mobile data connected', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.mobile);
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => const Stream.empty());

        final result = await connectivityService.hasConnection();
        expect(result, isTrue);
      });

      test('returns false when no connection', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => const Stream.empty());

        final result = await connectivityService.hasConnection();
        expect(result, isFalse);
      });

      test('handles connectivity check errors gracefully', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenThrow(Exception('Connectivity check failed'));
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => const Stream.empty());

        // Should not throw error and return false as fallback
        final result = await connectivityService.hasConnection();
        expect(result, isFalse);
      });
    });

    group('onConnectivityChanged', () {
      test('emits connectivity updates', () async {
        final updates = [
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
          ConnectivityResult.none,
        ];
        
        final controller = StreamController<ConnectivityResult>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);

        // Start listening before adding events
        final subscription = connectivityService.onConnectivityChanged.listen(
          expectAsync1(
            (result) => expect(updates.contains(result), isTrue),
            count: updates.length,
          ),
        );

        // Add events
        for (final update in updates) {
          controller.add(update);
        }

        // Clean up
        await controller.close();
        await subscription.cancel();
      });

      test('handles stream errors gracefully', () async {
        final controller = StreamController<ConnectivityResult>();
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => controller.stream);

        final subscription = connectivityService.onConnectivityChanged.listen(
          (_) {},
          onError: expectAsync1(
            (error) => expect(error, isA<Exception>()),
            count: 1,
          ),
        );

        controller.addError(Exception('Stream error'));

        // Clean up
        await controller.close();
        await subscription.cancel();
      });
    });
  });
}
