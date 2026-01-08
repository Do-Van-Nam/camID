import 'package:cam_id/main/base/base_response_v2.dart';
import 'package:cam_id/main/base/base_result.dart';
import 'package:cam_id/main/data/api/api_end_point.dart';
import 'package:cam_id/main/data/api/api_util.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';

class ServiceRepository {
  ServiceRepository._();
  static final ServiceRepository _instance = ServiceRepository._();
  factory ServiceRepository() => _instance;

  final Map<String, List<PackageModel>> _cache = {};

  Future<List<PackageModel>> getServiceByGroup(String type, {bool force=false}) async {
    if (!force && _cache.containsKey(type)) {
      return _cache[type]!;
    }

    final isdn = await SharePreferenceUtil.getString(ShareKey.KEY_PHONE_NUMBER);
    final language = await SharePreferenceUtil.getLanguageCode();

    final body = {
      "wsCode": "wsGetServicesByGroup",
      "wsRequest": {
        "language": language,
        "serviceGroupId": type,
        "isdn": isdn,
      },
    };

    final result = await ApiUtil.getInstance()!
        .postParsed<BaseResponseV2<BaseResult<List<PackageModel>>>>(
      url: ApiEndPoint.API_USER_ROUTING,
      body: body,
      fromJson: (json) => BaseResponseV2.fromJson(
        json,
            (data) => BaseResult<List<PackageModel>>.fromJson(
          data,
              (list) => (list as List)
              .map((e) => PackageModel.fromJson(e))
              .toList(),
        ),
      ),
    );

    if (result.isSuccess && result.result?.wsResponse != null) {
      final packages = result.result!.wsResponse!;
      _cache[type] = packages;
      return packages;
    }

    throw Exception(result.errorMessage ?? 'GetServiceByGroup failed');
  }

  void clearCache(String type) => _cache.remove(type);
  void clearAllCache() => _cache.clear();
}
