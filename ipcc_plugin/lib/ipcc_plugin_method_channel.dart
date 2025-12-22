import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ipcc_plugin_platform_interface.dart';

/// An implementation of [IpccPluginPlatform] that uses method channels.
class MethodChannelIpccPlugin extends IpccPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ipcc_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
