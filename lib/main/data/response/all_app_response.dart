import 'package:cam_id/main/data/model/app_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';

class GetAllAppResponse {
  List<AppModel>? apps;
  List<AdsModel>? adBanner;

  GetAllAppResponse({
    this.apps,
    this.adBanner,
  });

  factory GetAllAppResponse.fromJson(Map<String, dynamic> json) {
    return GetAllAppResponse(
      apps: (json['apps'] as List<dynamic>?)
          ?.map((e) => AppModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      adBanner: (json['adBanner'] as List<dynamic>?)
          ?.map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apps': apps?.map((e) => e.toJson()).toList(),
      'adBanner': adBanner?.map((e) => e.toJson()).toList(),
    };
  }
}
