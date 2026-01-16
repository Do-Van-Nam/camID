import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/chatbot/chatbot_response_model.dart';
import 'package:cam_id/main/data/model/game/game_data_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/utils/device_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GameRepository {
  GameRepository._();
  static final GameRepository _instance = GameRepository._();
  factory GameRepository() => _instance;

  // Cache nếu cần (ví dụ: menu ngôn ngữ ít thay đổi, có thể cache theo chatId)
  // Hiện tại mình để optional, nếu bạn muốn cache thì uncomment và mở rộng
  // Map<String, ChatbotResponse> _menuCache = {}; // Key: chatId

  Future<GameData> getGames(
    // {
    ///  required String chatId,
    // required String buttonCallback,
    // required String wsCode,
    // required String question,
    // String? language, // Nếu null thì lấy từ SharedPreference
    // bool force = false,
    // }
  ) async {
    // Nếu có cache và không force → trả về cache
    // if (!force && _menuCache.containsKey(chatId)) {
    //   return _menuCache[chatId]!;
    // }

    // Lấy dữ liệu động
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    // final lang = language ?? await SharePreferenceUtil.getLanguageCode();
    final versionApp = await PackageInfo.fromPlatform().then((e) => e.version);
    final chatId = DeviceUtils.getDeviceId();
    final body = {
      // get-menu : khi nhan nut hoac ban dau,
      // faq-query question : khi chon hoac nhap noi dung gui len
      // suggest-menu  question :
      // "wsCode": wsCode, // Hoặc dùng const WSCode.getMenu nếu bạn có enum
      "username": isdn,
      "apiKey": ApiEndPoint.API_KEY_V2,
      // "language": lang,
      "sessionId": "", // Nếu user login thì lấy từ storage
      "token": "",
      "versionApp": versionApp,
      "wsRequest": {
        // "buttonCallback": buttonCallback,
        "chatId": chatId,
        // "question": question,
      },
    };

    // postParsed trả về Map<String, dynamic>, không phải BaseResponse
    final responseMap = await ApiUtil.getInstance()!
        .postParsed<Map<String, dynamic>>(
          url: ApiEndPoint.API_GAME_GAMES,
          body: body,
          fromJson: (json) => json as Map<String, dynamic>, // Chỉ cast về Map
        );

    // Kiểm tra và parse thủ công
    if (responseMap != null && responseMap['code'] == '00') {
      final gameDataMap = responseMap['data'] as Map<String, dynamic>?;

      if (gameDataMap != null) {
        final gameData = GameData.fromJson(gameDataMap);
        return gameData;
      }
    }

    throw Exception(responseMap["errMessage"] ?? 'GetMenu failed');
  }

  // Nếu cần clear cache (ví dụ khi logout hoặc thay đổi chatId)
  void clearCache() {
    // _menuCache.clear();
  }

  // Phương thức bổ sung nếu bạn muốn lấy full response (tương tự getMenuFullResponse trước đó)
  Future<BaseResponseV2<BaseResult<ChatbotResponse>>> getMenuFullResponse({
    required String chatId,
    String buttonCallback = 'list_language',
    String? language,
  }) async {
    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final lang = language ?? await SharePreferenceUtil.getLanguageCode();
    final versionApp = await PackageInfo.fromPlatform().then((e) => e.version);

    final body = {
      "wsCode": "get-menu",
      "username": isdn,
      "apiKey": ApiEndPoint.API_KEY_V2,
      "language": lang,
      "sessionId": "",
      "token": "",
      "versionApp": versionApp,
      "wsRequest": {"buttonCallback": buttonCallback, "chatId": chatId},
    };

    return await ApiUtil.getInstance()!
        .postParsed<BaseResponseV2<BaseResult<ChatbotResponse>>>(
          url: ApiEndPoint.API_USER_ROUTING,
          body: body,
          fromJson: (json) => BaseResponseV2.fromJson(
            json,
            (data) => BaseResult<ChatbotResponse>.fromJson(
              data,
              (ws) => ChatbotResponse.fromJson(ws),
            ),
          ),
        );
  }
}
