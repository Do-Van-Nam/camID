import 'package:flutter_test/flutter_test.dart';
import 'package:ipcc_plugin/ipcc_plugin.dart';
import 'package:ipcc_plugin/ipcc_plugin_platform_interface.dart';
import 'package:ipcc_plugin/ipcc_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIpccPluginPlatform
    with MockPlatformInterfaceMixin
    implements IpccPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IpccPluginPlatform initialPlatform = IpccPluginPlatform.instance;

  test('$MethodChannelIpccPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIpccPlugin>());
  });

  // test('getPlatformVersion', () async {
  //   IpccPlugin ipccPlugin = IpccPlugin();
  //   MockIpccPluginPlatform fakePlatform = MockIpccPluginPlatform();
  //   IpccPluginPlatform.instance = fakePlatform;
  //
  //   expect(await ipccPlugin.getPlatformVersion(), '42');
  // });
}
