import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Keyra/core/presentation/bloc/connectivity_bloc.dart';
import 'package:Keyra/core/presentation/widgets/connectivity_monitor.dart';
import 'package:Keyra/features/common/presentation/widgets/no_internet_dialog.dart';
import 'package:Keyra/core/services/connectivity_service.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';

// Mocks
class MockConnectivityService extends Mock implements ConnectivityService {}
class MockConnectivity extends Mock implements Connectivity {}

// Custom UiTranslations for testing
class TestUiTranslations extends StatelessWidget {
  final Widget child;

  const TestUiTranslations({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UiTranslations(
      currentLanguage: 'en',
      child: child,
    );
  }
}

// Custom Bloc implementation for testing
class TestConnectivityBloc extends Cubit<ConnectivityState> implements ConnectivityBloc {
  TestConnectivityBloc() : super(ConnectivityState(
    isConnected: true,
    hasCheckedInitially: true,
  ));

  @override
  bool get isConnected => state.isConnected;

  @override
  void add(ConnectivityEvent event) {
    // Handle events if needed
  }

  @override
  void onEvent(ConnectivityEvent event) {
    // Handle events if needed
  }

  @override
  void on<E extends ConnectivityEvent>(
    FutureOr<void> Function(E event, Emitter<ConnectivityState> emit) handler, {
    EventTransformer<E>? transformer,
  }) {
    // Not needed for tests
  }

  @override
  void onTransition(Transition<ConnectivityEvent, ConnectivityState> transition) {
    // Not needed for tests
  }
}

void main() {
  late MockConnectivityService mockConnectivityService;
  late MockConnectivity mockConnectivity;
  late TestConnectivityBloc connectivityBloc;

  setUp(() {
    mockConnectivityService = MockConnectivityService();
    mockConnectivity = MockConnectivity();
    connectivityBloc = TestConnectivityBloc();
  });

  tearDown(() {
    connectivityBloc.close();
  });

  Widget createTestWidget({required Widget child}) {
    return TestUiTranslations(
      child: MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<ConnectivityService>.value(value: mockConnectivityService),
            BlocProvider<ConnectivityBloc>.value(value: connectivityBloc),
          ],
          child: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => child,
            ),
          ),
        ),
      ),
    );
  }

  group('Connectivity Tests', () {
    testWidgets('Shows no internet dialog when offline', (tester) async {
      // Arrange
      when(() => mockConnectivityService.hasConnection())
          .thenAnswer((_) async => false);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      // Build test widget
      await tester.pumpWidget(
        createTestWidget(
          child: const ConnectivityMonitor(
            child: Scaffold(
              body: Center(
                child: Text('Test Content'),
              ),
            ),
          ),
        ),
      );

      // First emit connected state to establish initial state
      connectivityBloc.emit(ConnectivityState(
        isConnected: true,
        hasCheckedInitially: true,
      ));
      await tester.pump();

      // Then emit disconnected state to trigger the listener
      connectivityBloc.emit(ConnectivityState(
        isConnected: false,
        hasCheckedInitially: true,
      ));

      await tester.pumpAndSettle(); // Wait for dialog animation

      // Assert
      expect(find.byType(NoInternetDialog), findsOneWidget);
      expect(find.text('Connection Error'), findsOneWidget);
      expect(
        find.text('No internet connection available. Please check your connection and try again.'),
        findsOneWidget,
      );
    });

    testWidgets('Hides dialog when connection is restored', (tester) async {
      // Arrange
      when(() => mockConnectivityService.hasConnection())
          .thenAnswer((_) async => true);
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);

      // Build test widget
      await tester.pumpWidget(
        createTestWidget(
          child: const ConnectivityMonitor(
            child: Scaffold(
              body: Center(
                child: Text('Test Content'),
              ),
            ),
          ),
        ),
      );

      // First emit disconnected state to show dialog
      connectivityBloc.emit(ConnectivityState(
        isConnected: false,
        hasCheckedInitially: true,
      ));
      await tester.pumpAndSettle(); // Wait for dialog animation

      // Verify dialog is shown
      expect(find.byType(NoInternetDialog), findsOneWidget);

      // Then emit connected state to hide dialog
      connectivityBloc.emit(ConnectivityState(
        isConnected: true,
        hasCheckedInitially: true,
      ));
      await tester.pumpAndSettle(); // Wait for dialog animation

      // Verify dialog is hidden
      expect(find.byType(NoInternetDialog), findsNothing);
    });

    testWidgets('Shows dialog on manual connectivity check when offline',
        (tester) async {
      // Arrange
      when(() => mockConnectivityService.hasConnection())
          .thenAnswer((_) async => false);

      // Build test widget
      await tester.pumpWidget(
        createTestWidget(
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final hasConnection = await context.read<ConnectivityService>().hasConnection();
                    if (!hasConnection) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const NoInternetDialog(),
                        );
                      }
                    }
                  },
                  child: const Text('Check Connection'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap button to trigger connectivity check
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(); // Wait for dialog animation

      // Verify dialog is shown
      expect(find.byType(NoInternetDialog), findsOneWidget);
      expect(find.text('Connection Error'), findsOneWidget);
      expect(
        find.text('No internet connection available. Please check your connection and try again.'),
        findsOneWidget,
      );
    });
  });
}
