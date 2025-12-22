import 'package:flutter/services.dart';

class IpccChannel {
  static const _channel = MethodChannel('ipcc');

  static Future<void> initSdk() =>
      _channel.invokeMethod('initSdk');

  static Future<void> showCall(String camId) =>
      _channel.invokeMethod('showCall', {'camId': camId});

  static Future<void> showVideoCall(String camId) =>
      _channel.invokeMethod('showVideoCall', {'camId': camId});

  static void setOnClosed(VoidCallback callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onClosed') {
        callback();
      }
    });
  }
}
