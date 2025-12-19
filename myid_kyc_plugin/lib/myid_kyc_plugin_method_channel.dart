import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'myid_kyc_plugin_platform_interface.dart';

/// An implementation of [MyidKycPluginPlatform] that uses method channels.
class MethodChannelMyidKycPlugin extends MyidKycPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('myid_kyc_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
