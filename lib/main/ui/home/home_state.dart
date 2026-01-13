import 'package:cam_id/main/data/model/accounts_ocs_detail_v2_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}
class OnStarted extends HomeState {
  final bool isLoggedIn;

  OnStarted(this.isLoggedIn);
}
class OnTapLogin extends HomeState {
}

class GetAllAppSuccess extends HomeState {
  final List<AdsModel>? listBanner;
  final List<AdsModel>? listVas;

  GetAllAppSuccess(this.listBanner, this.listVas);

}

class GetAllAppFailure extends HomeState {
  final String message;

  GetAllAppFailure(this.message);
}

class GetServiceByGroupSuccess extends HomeState {
  final List<PackageModel>? listPackage;

  GetServiceByGroupSuccess(this.listPackage);

}

class GetServiceByGroupFailure extends HomeState {
  final String message;

  GetServiceByGroupFailure(this.message);
}

class GetAccountsOcsDetailSuccess extends HomeState {
  final AccountsOcsDetailV2Model? ocsBasic;
  final AccountsOcsDetailV2Model? ocsData;
  final AccountsOcsDetailV2Model? ocsCall;
  final AccountsOcsDetailV2Model? ocsSms;
  final AccountsOcsDetailV2Model? ocsRoaming;

  GetAccountsOcsDetailSuccess(this.ocsBasic, this.ocsData, this.ocsCall, this.ocsSms, this.ocsRoaming);


}

class GetAccountsOcsDetailFailure extends HomeState {
  final String message;

  GetAccountsOcsDetailFailure(this.message);
}


class SignUpSuccess extends HomeState {
  final String message;

  SignUpSuccess(this.message);
}

class SignUpFailure extends HomeState {
  final String message;

  SignUpFailure(this.message);
}

class GenerateOTPSuccess extends HomeState {
  final String message;

  GenerateOTPSuccess(this.message);
}

class GenerateOTPFailure extends HomeState {
  final String message;

  GenerateOTPFailure(this.message);
}

class SignInSuccess extends HomeState {
  final String message;
  final SignInModel data;

  SignInSuccess(this.message, this.data);
}

class SignInFailure extends HomeState {
  final String message;

  SignInFailure(this.message);
}

class GetUserInfoSuccess extends HomeState {
  final String message;
  final UserInfoModel? user;
  final List<ServiceModel>? services;
  final ImageKycModel? imageKyc;

  GetUserInfoSuccess(
      this.message,
      this.user,
      this.services,
      this.imageKyc,
      );
}

class GetUserInfoFailure extends HomeState {
  final String message;

  GetUserInfoFailure(this.message);
}

