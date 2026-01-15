import 'package:cam_id/main/data/model/acount_ftth_model.dart';
import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:cam_id/main/data/model/ftth_package_model.dart';
import 'package:equatable/equatable.dart';

class InternetWifiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InternetWifiInitial extends InternetWifiState {}

class InternetWifiLoading extends InternetWifiState {}
class LoginFTTHLoading extends InternetWifiState {}

class GetFTTHAccountSuccess extends InternetWifiState {
  final FTTHAccountModel ftthAccount;

  GetFTTHAccountSuccess(this.ftthAccount);
}

class GetFTTHAccountFailure extends InternetWifiState {
  final String message;

  GetFTTHAccountFailure(this.message);
}

class GetFTTHPackagesSuccess extends InternetWifiState {
  final List<PackageFtthModel>? listPackageFTTH;

  GetFTTHPackagesSuccess(this.listPackageFTTH);
}

class GetFTTHPackagesFailure extends InternetWifiState {
  final String message;

  GetFTTHPackagesFailure(this.message);
}

class GetAllAppSuccess extends InternetWifiState {
  final List<AdsModel>? listBanner;

  GetAllAppSuccess(this.listBanner);
}

class GetAllAppFailure extends InternetWifiState {
  final String message;

  GetAllAppFailure(this.message);
}

class SendIDFTTHSuccess extends InternetWifiState {

}

class SendIDFTTHFailure extends InternetWifiState {
  final String message;

  SendIDFTTHFailure(this.message);
}

class SearchFTTHAccountByPhoneSuccess extends InternetWifiState {

}

class SearchFTTHAccountByPhoneFailure extends InternetWifiState {
  final String message;

  SearchFTTHAccountByPhoneFailure(this.message);
}