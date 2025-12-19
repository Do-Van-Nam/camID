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
    if (json['data'] != null && json['data']['user'] != null) {
      UserInfoModel.instance.fromJson(json['data']['user']);
    }

    List<ServiceModel>? services;
    if (json['data'] != null && json['data']['services'] != null) {
      services = (json['data']['services'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList();
    }

    ImageKycModel? imageKyc;
    if (json['data'] != null && json['data']['imageKyc'] != null) {
      imageKyc = ImageKycModel.fromJson(json['data']['imageKyc']);
    }

    UserInfoResponse response = UserInfoResponse(
      user: UserInfoModel.instance,
      services: services,
      imageKyc: imageKyc,
    );

    response.code = json['code'];
    response.message = json['message'];

    return response;
  }

}
