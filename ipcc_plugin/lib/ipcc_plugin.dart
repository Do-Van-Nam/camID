
import 'ipcc_plugin_platform_interface.dart';

import 'package:flutter/services.dart';

class IpccPlugin {
  static const _channel = MethodChannel('ipcc_plugin');

  static Future<void> initConfig() async {
    await _channel.invokeMethod('initConfig');
  }

  static Future<void> initSdk() async {
    await _channel.invokeMethod('initSdk');
  }

  static Future<void> showCall(String camId) async {
    await _channel.invokeMethod('showCall', {
      'camId': camId,
    });
  }

  static Future<void> showVideoCall(String camId) async {
    await _channel.invokeMethod('showVideoCall', {
      'camId': camId,
    });
  }

  static void setOnClosed(void Function() callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onClosed') {
        callback();
      }
    });
  }
}
