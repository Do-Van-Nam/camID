import 'dart:async';
import 'package:flutter/services.dart';

class MyidKycPlugin {
  static const MethodChannel _channel = MethodChannel('myid_kyc_plugin');

  static Future<Map<String, dynamic>?> startKYC({
    required String licenseKey,
    required String sessionId, // hoặc các param khác
  }) async {
    try {
      final result = await _channel.invokeMethod('startKYC', {
        'licenseKey': licenseKey,
        'sessionId': sessionId,
      });
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw Exception('KYC failed: ${e.message}');
    }
  }
}
