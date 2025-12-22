
import 'package:flutter/services.dart';

import 'speed_test_plugin_platform_interface.dart';

class SpeedTestPlugin {
  static const _channel = MethodChannel('speed_test_plugin');

  static Future<void> navigateSpeedTest(
      String phone,
      String deviceId,
      String userId,
      String language,
      ) async {
    await _channel.invokeMethod('navigateSpeedTest', {
      'phone': phone,
      'deviceId': deviceId,
      'userId': userId,
      'language': language,
    });
  }
}
