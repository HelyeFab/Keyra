import 'package:battery_plus/battery_plus.dart';

class BatteryMonitoringService {
  final Battery _battery;
  int? _startLevel;
  DateTime? _startTime;
  Duration? _simulatedDuration;

  BatteryMonitoringService({Battery? battery}) : _battery = battery ?? Battery();

  Future<void> startMonitoring() async {
    _startLevel = await _battery.batteryLevel;
    _startTime = DateTime.now();
    _simulatedDuration = null;
  }

  void setSimulatedDuration(Duration duration) {
    _simulatedDuration = duration;
  }

  Future<BatteryUsageResult> stopMonitoring() async {
    if (_startLevel == null || _startTime == null) {
      throw StateError('Monitoring not started');
    }

    final endLevel = await _battery.batteryLevel;
    final duration = _simulatedDuration ?? DateTime.now().difference(_startTime!);
    final batteryDrain = _startLevel! - endLevel;
    final drainPerHour = batteryDrain * (const Duration(hours: 1).inMinutes / duration.inMinutes);

    return BatteryUsageResult(
      startLevel: _startLevel!,
      endLevel: endLevel,
      duration: duration,
      batteryDrain: batteryDrain,
      drainPerHour: drainPerHour,
    );
  }

  Future<bool> isCharging() async {
    final status = await _battery.batteryState;
    return status == BatteryState.charging;
  }
}

class BatteryUsageResult {
  final int startLevel;
  final int endLevel;
  final Duration duration;
  final int batteryDrain;
  final double drainPerHour;

  const BatteryUsageResult({
    required this.startLevel,
    required this.endLevel,
    required this.duration,
    required this.batteryDrain,
    required this.drainPerHour,
  });

  @override
  String toString() => 
    'Battery drain: $batteryDrain% over ${duration.inMinutes}min (${drainPerHour.toStringAsFixed(1)}%/hour)';
}
