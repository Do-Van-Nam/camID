import 'package:url_launcher/url_launcher.dart';

// Hàm mở URL chung
Future<void> launchApp(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode:
        LaunchMode
            .externalApplication, // Mở app ngoài (Telegram/Messenger) nếu có
  )) {
    throw Exception('Không thể mở $url');
  }
}
