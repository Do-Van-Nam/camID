import 'package:url_launcher/url_launcher.dart';

// Hàm mở URL chung
Future<void> launchApp(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode
        .externalApplication, // Mở app ngoài (Telegram/Messenger) nếu có
  )) {
    throw Exception('Không thể mở $url');
  }
}

int compareVersion(String v1, String v2) {
  List<int> parse(String v) {
    // Bỏ suffix như -beta, +build
    v = v.split(RegExp(r'[-+]')).first;

    return v.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  final a = parse(v1);
  final b = parse(v2);

  final maxLength = a.length > b.length ? a.length : b.length;

  for (int i = 0; i < maxLength; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;

    if (x > y) return 1;
    if (x < y) return -1;
  }

  return 0;
}

String formatWithDots(num value) {
  final isNegative = value < 0;
  final parts = value.abs().toString().split('.');
  final integerPart = parts[0];
  final formattedInt = integerPart.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  final result = parts.length > 1 ? '$formattedInt,${parts[1]}' : formattedInt;
  return isNegative ? '-$result' : result;
}
