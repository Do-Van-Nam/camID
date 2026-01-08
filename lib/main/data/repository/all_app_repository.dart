import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/response/all_app_response.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRepository {
  AppRepository._();
  static final AppRepository _instance = AppRepository._();
  factory AppRepository() => _instance;

  GetAllAppResponse? _cache;

  Future<GetAllAppResponse> getAllApps({bool force = false}) async {
    if (!force && _cache != null) {
      return _cache!;
    }

    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final language = await SharePreferenceUtil.getLanguageCode();
    final versionApp = await PackageInfo.fromPlatform().then((e) => e.version);

    final body = {
      "wsCode": "wsGetAllApps",
      "username": isdn,
      "apiKey": ApiEndPoint.API_KEY_V2,
      "wsRequest": {
        "language": language,
        "versionApp": versionApp,
        "isdn": isdn,
      },
    };

    final result = await ApiUtil.getInstance()!.postParsed<
        BaseResponseV2<BaseResult<GetAllAppResponse>>>(
      url: ApiEndPoint.API_USER_ROUTING,
      body: body,
      fromJson: (json) => BaseResponseV2.fromJson(
        json,
            (data) => BaseResult<GetAllAppResponse>.fromJson(
          data,
              (ws) => GetAllAppResponse.fromJson(ws),
        ),
      ),
    );

    if (result.isSuccess && result.result?.wsResponse != null) {
      _cache = result.result!.wsResponse!;
      return _cache!;
    }

    throw Exception(result.errorMessage ?? 'GetAllApps failed');
  }


  void clearCache() {
    _cache = null;
  }
}