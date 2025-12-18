import 'dart:convert';

import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareKey {
  static const String KEY_CHANGE_LANGUAGE = "KEY_CHANGE_LANGUAGE";
  static const String KEY_USER_INFO = "KEY_USER_INFO";
  static const String KEY_FB_TOKEN = "KEY_FB_TOKEN";
  static const String KEY_LOG_FILE = "KEY_LOG_FILE";
  static const String KEY_FIRST_OPEN_APP = "KEY_FIRST_OPEN_APP";
  static const String KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN";
  static const String KEY_PHONE_NUMBER = "KEY_PHONE_NUMBER";
  static const String KEY_REFRESH_TOKEN = "KEY_REFRESH_TOKEN";
  static const String KEY_LOGIN_WITH_OTP = "KEY_LOGIN_WITH_OTP";

}

class SharePreferenceUtil {
  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(key, value);
  }

  static Future<String> getString(
      String key, {
        String defaultValue = '',
      }) async {
    final prefs = await _prefs();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(
      String key, {
        bool defaultValue = false,
      }) async {
    final prefs = await _prefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs();
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(
      String key, {
        int defaultValue = 0,
      }) async {
    final prefs = await _prefs();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs();
    await prefs.setDouble(key, value);
  }

  static Future<double> getDouble(
      String key, {
        double defaultValue = 0.0,
      }) async {
    final prefs = await _prefs();
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    final prefs = await _prefs();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    final prefs = await _prefs();
    return prefs.clear();
  }

  static Future saveLanguage(String languageCode) async {
    return setString(ShareKey.KEY_CHANGE_LANGUAGE, languageCode);
  }

  static Future<String> getLanguageCode() async {
    return getString(
      ShareKey.KEY_CHANGE_LANGUAGE,
      defaultValue: 'en',
    );
  }

  static Future<void> saveUser(UserInfoModel? model) async {
    final jsonString = jsonEncode(model);
    return setString(ShareKey.KEY_USER_INFO, jsonString);
  }

  static Future<UserInfoModel?> getUser() async {
    final jsonString = await getString(ShareKey.KEY_USER_INFO);
    if (jsonString.isEmpty) return null;
    final jsonMap = jsonDecode(jsonString);
    final user = UserInfoModel.instance;
    user.fromJson(jsonMap);
    return user;
  }

  static Future saveToken(String token) async {
    return setString(ShareKey.KEY_FB_TOKEN, token);
  }

  static Future<String> getToken() async {
    return getString(ShareKey.KEY_FB_TOKEN);
  }

  static Future saveLogFile(bool enable) async {
    return setBool(ShareKey.KEY_LOG_FILE, enable);
  }

  static Future<bool> enableLogFile() async {
    return getBool(ShareKey.KEY_LOG_FILE);
  }

  static Future<bool> removeKey(String key) async {
    return remove(key);
  }
}