import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';

class UserInfoResponse {
  UserInfoModel? user;
  List<ServiceModel>? services;
  ImageKycModel? imageKyc;
}