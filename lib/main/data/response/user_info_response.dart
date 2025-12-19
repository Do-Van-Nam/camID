import 'package:cam_id/main/base/base_response.dart';
import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';

class UserInfoResponse extends BaseResponse{
  UserInfoModel? user;
  List<ServiceModel>? services;
  ImageKycModel? imageKyc;

  UserInfoResponse({
    this.user,
    this.services,
    this.imageKyc,
  }) : super.success();

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      UserInfoModel.instance.fromJson(json['user']);
    }
    List<ServiceModel>? services;
    if (json['services'] != null) {
      services = (json['services'] as List)
          .map((e) {
        final service = ServiceModel();
        service.fromJson(e);
        return service;
      })
          .toList();
    }
    ImageKycModel? imageKyc;
    if (json['imageKyc'] != null) {
      imageKyc = ImageKycModel();
      imageKyc.fromJson(json['imageKyc']);
    }

    return UserInfoResponse(
      user: UserInfoModel.instance,
      services: services,
      imageKyc: imageKyc,
    );
  }

}
