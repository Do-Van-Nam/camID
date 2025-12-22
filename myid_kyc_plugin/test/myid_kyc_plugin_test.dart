import 'package:flutter_test/flutter_test.dart';
import 'package:myid_kyc_plugin/myid_kyc_plugin.dart';
import 'package:myid_kyc_plugin/myid_kyc_plugin_platform_interface.dart';
import 'package:myid_kyc_plugin/myid_kyc_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMyidKycPluginPlatform
    with MockPlatformInterfaceMixin
    implements MyidKycPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MyidKycPluginPlatform initialPlatform = MyidKycPluginPlatform.instance;

  test('$MethodChannelMyidKycPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMyidKycPlugin>());
  });

  test('getPlatformVersion', () async {
    MyidKycPlugin myidKycPlugin = MyidKycPlugin();
    MockMyidKycPluginPlatform fakePlatform = MockMyidKycPluginPlatform();
    MyidKycPluginPlatform.instance = fakePlatform;

    expect(await myidKycPlugin.getPlatformVersion(), '42');
  });
}
