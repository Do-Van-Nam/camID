import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speed_test_plugin_method_channel.dart';

abstract class SpeedTestPluginPlatform extends PlatformInterface {
  /// Constructs a SpeedTestPluginPlatform.
  SpeedTestPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeedTestPluginPlatform _instance = MethodChannelSpeedTestPlugin();

  /// The default instance of [SpeedTestPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSpeedTestPlugin].
  static SpeedTestPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpeedTestPluginPlatform] when
  /// they register themselves.
  static set instance(SpeedTestPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
