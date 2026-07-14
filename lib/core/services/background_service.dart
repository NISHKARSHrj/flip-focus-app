import 'package:flutter/services.dart';

class BackgroundService {
  static const MethodChannel _channel =
      MethodChannel('flip/background');

  static Future<void> start() async {
    await _channel.invokeMethod('startService');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopService');
  }
}