import 'package:cam_id/app.dart';
import 'package:flutter/material.dart';
import 'package:ipcc_plugin/ipcc_plugin.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initIpccSdk();
  }

  Future<void> _initIpccSdk() async {
    try {
      // await IpccPlugin.initSdk();    // init FragmentManager + context
      await IpccPlugin.initConfig(); // set LiveConfig
    } catch (e) {
      debugPrint("IPCC SDK init error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
