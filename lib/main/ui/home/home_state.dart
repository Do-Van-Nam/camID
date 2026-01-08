import 'package:cam_id/main/data/model/accounts_ocs_detail_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/mobile_package_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  // final bool isLoading;
  // final bool isLoggedIn;
  // final int bannerIndex;
  // final bool navigateToLogin;
  // final List<AdsModel>? listBannerFooter;
  // final List<AdsModel>? listVasService;
  // final List<PackageModel>? listPackageMobile;
  // final AccountsOcsDetailModel? ocsBasic;
  // final AccountsOcsDetailModel? ocsData;
  // final AccountsOcsDetailModel? ocsCall;
  // final AccountsOcsDetailModel? ocsSms;
  // final AccountsOcsDetailModel? ocsRoaming;
  // final bool signUpSuccess;
  // final bool signInSuccess;
  // final SignInModel? signInModel;
  // final String? error;
  //
  // const HomeState({
  //   required this.isLoggedIn,
  //   required this.bannerIndex,
  //   this.navigateToLogin = false,
  //   this.listBannerFooter,
  //   this.listVasService,
  //   this.listPackageMobile,
  //   required this.isLoading,
  //   this.error,
  //   this.ocsBasic,
  //   this.ocsData,
  //   this.ocsCall,
  //   this.ocsSms,
  //   this.ocsRoaming,
  //   this.signUpSuccess = false,
  //   this.signInSuccess = false,
  //   this.signInModel,
  // });

  // factory HomeState.initial() {
  //   return HomeState(
  //     isLoggedIn: UserInfoModel.instance.username.isNotEmpty,
  //     bannerIndex: 0,
  //     isLoading: false,
  //   );
  // }
  //
  // HomeState copyWith({
  //   bool? isLoggedIn,
  //   int? bannerIndex,
  //   bool? isLoading,
  //   bool? navigateToLogin,
  //   List<AdsModel>? listBannerFooter,
  //   List<AdsModel>? listVasService,
  //   List<PackageModel>? listPackageMobile,
  //   AccountsOcsDetailModel? ocsBasic,
  //   AccountsOcsDetailModel? ocsData,
  //   AccountsOcsDetailModel? ocsCall,
  //   AccountsOcsDetailModel? ocsSms,
  //   AccountsOcsDetailModel? ocsRoaming,
  //   bool? signUpSuccess,
  //   bool? signInSuccess,
  //   SignInModel? signInModel,
  //   String? error,
  // }) {
  //   return HomeState(
  //     isLoading: isLoading ?? this.isLoading,
  //     isLoggedIn: isLoggedIn ?? this.isLoggedIn,
  //     bannerIndex: bannerIndex ?? this.bannerIndex,
  //     navigateToLogin: navigateToLogin ?? false,
  //     listBannerFooter: listBannerFooter ?? this.listBannerFooter,
  //     listVasService: listVasService ?? this.listVasService,
  //     listPackageMobile: listPackageMobile ?? this.listPackageMobile,
  //     ocsBasic: ocsBasic ?? this.ocsBasic,
  //     ocsData: ocsData ?? this.ocsData,
  //     ocsCall: ocsCall ?? this.ocsCall,
  //     ocsSms: ocsSms ?? this.ocsSms,
  //     ocsRoaming: ocsRoaming ?? this.ocsRoaming,
  //     signUpSuccess: signUpSuccess ?? this.signUpSuccess,
  //     signInSuccess: signInSuccess ?? this.signInSuccess,
  //     signInModel: signInModel ?? this.signInModel,
  //     error: error,
  //   );
  // }

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
  final AccountsOcsDetailModel? ocsBasic;
  final AccountsOcsDetailModel? ocsData;
  final AccountsOcsDetailModel? ocsCall;
  final AccountsOcsDetailModel? ocsSms;
  final AccountsOcsDetailModel? ocsRoaming;

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

class SignInLoading extends HomeState {}

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

