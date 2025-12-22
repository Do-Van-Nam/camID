import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'myid_kyc_plugin_method_channel.dart';

abstract class MyidKycPluginPlatform extends PlatformInterface {
  /// Constructs a MyidKycPluginPlatform.
  MyidKycPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyidKycPluginPlatform _instance = MethodChannelMyidKycPlugin();

  /// The default instance of [MyidKycPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelMyidKycPlugin].
  static MyidKycPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyidKycPluginPlatform] when
  /// they register themselves.
  static set instance(MyidKycPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
