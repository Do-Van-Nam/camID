import 'package:flutter_test/flutter_test.dart';
import 'package:speed_test_plugin/speed_test_plugin.dart';
import 'package:speed_test_plugin/speed_test_plugin_platform_interface.dart';
import 'package:speed_test_plugin/speed_test_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSpeedTestPluginPlatform
    with MockPlatformInterfaceMixin
    implements SpeedTestPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpeedTestPluginPlatform initialPlatform = SpeedTestPluginPlatform.instance;

  test('$MethodChannelSpeedTestPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpeedTestPlugin>());
  });

  test('getPlatformVersion', () async {
    SpeedTestPlugin speedTestPlugin = SpeedTestPlugin();
    MockSpeedTestPluginPlatform fakePlatform = MockSpeedTestPluginPlatform();
    SpeedTestPluginPlatform.instance = fakePlatform;

    expect(await speedTestPlugin.getPlatformVersion(), '42');
  });
}
