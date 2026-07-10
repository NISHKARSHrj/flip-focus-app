import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';

class BatteryService {
  static Future<bool> isBatteryOptimizationDisabled() async {
    return await DisableBatteryOptimizationLatest
            .isBatteryOptimizationDisabled ??
        false;
  }

  static Future<void> requestDisableBatteryOptimization() async {
    await DisableBatteryOptimizationLatest
        .showDisableBatteryOptimizationSettings();
  }
}