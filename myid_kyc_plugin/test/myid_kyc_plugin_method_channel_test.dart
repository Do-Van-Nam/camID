import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myid_kyc_plugin/myid_kyc_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMyidKycPlugin platform = MethodChannelMyidKycPlugin();
  const MethodChannel channel = MethodChannel('myid_kyc_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
