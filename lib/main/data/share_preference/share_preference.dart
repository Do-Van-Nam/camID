import 'package:shared_preferences/shared_preferences.dart';

class ShareKey{
  static const String KEY_CHANGE_LANGUAGE = "change_language";
  static const String KEY_USER_INFO = "user_info";
  static const String KEY_FB_TOKEN = "fb_token";
  static const String KEY_LOG_FILE = "log_file";
}

class SharePreferenceUtil {
  static Future saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ShareKey.KEY_CHANGE_LANGUAGE, languageCode);
  }

  static Future<String> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ShareKey.KEY_CHANGE_LANGUAGE) ?? 'en';
  }

  static Future saveUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ShareKey.KEY_USER_INFO, user);
  }

  static Future<String> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ShareKey.KEY_USER_INFO) ?? '';
  }

  static Future<bool> removeKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ShareKey.KEY_FB_TOKEN, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ShareKey.KEY_FB_TOKEN) ?? '';
  }

  static Future saveLogFile(bool enable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ShareKey.KEY_LOG_FILE, enable);
  }

  static Future<bool> enableLogFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ShareKey.KEY_LOG_FILE) ?? false;
  }
}