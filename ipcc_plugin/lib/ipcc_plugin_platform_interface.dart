import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ipcc_plugin_method_channel.dart';

abstract class IpccPluginPlatform extends PlatformInterface {
  /// Constructs a IpccPluginPlatform.
  IpccPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static IpccPluginPlatform _instance = MethodChannelIpccPlugin();

  /// The default instance of [IpccPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelIpccPlugin].
  static IpccPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IpccPluginPlatform] when
  /// they register themselves.
  static set instance(IpccPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
