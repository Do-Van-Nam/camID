import 'package:cam_id/app.dart';
import 'package:cam_id/main/utils/service/deeplink_service.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/router.dart';
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
    _initDeeplinks();
  }

  Future<void> _initIpccSdk() async {
    try {
      // await IpccPlugin.initSdk();    // init FragmentManager + context
      await IpccPlugin.initConfig(); // set LiveConfig
    } catch (e) {
      debugPrint("IPCC SDK init error: $e");
    }
  }

  void _initDeeplinks() {
    DeeplinkService().init(
      onDeepLink: (Uri uri) {
        AppLogger().logInfo("Deeplink received: $uri");

        try {
          // Expect scheme như: camid://webview?ref=<encoded_url>
          if (uri.host == 'webview') {
            final rawUrl = uri.queryParameters['ref'];
            if (rawUrl == null || rawUrl.isEmpty) {
              AppLogger().logError("Deeplink missing 'url' parameter: $uri");
              return;
            }

            final decodedUrl = Uri.decodeComponent(rawUrl);
            final target = Uri.tryParse(decodedUrl);
            if (target == null ||
                (target.scheme != 'http' && target.scheme != 'https')) {
              AppLogger().logError("Invalid deeplink web URL: $decodedUrl");
              return;
            }

            // Mở WebView toàn màn hình bằng GoRouter
            router.goNamed('webview', extra: decodedUrl);
          }
        } catch (e, st) {
          AppLogger().logError("Handle deeplink error: $e\n$st");
        }
      },
    );
  }

  @override
  void dispose() {
    DeeplinkService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
