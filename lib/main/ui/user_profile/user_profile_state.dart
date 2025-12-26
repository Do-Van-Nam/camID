import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/response/linked_emoney_response.dart';
import 'package:cam_id/main/data/response/list_payment_method_response.dart';
import 'package:equatable/equatable.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class InitLinkedPaymentSuccess extends UserProfileState {
  final String message;

  InitLinkedPaymentSuccess(this.message);
}

class InitLinkedPaymentFailure extends UserProfileState {
  final String message;

  InitLinkedPaymentFailure(this.message);
}

class CheckLinkedPaymentEmoneySuccess extends UserProfileState {
  final String message;
  final CheckLinkResult? result;
  CheckLinkedPaymentEmoneySuccess(this.message, this.result);
}

class CheckLinkedPaymentEmoneyFailure extends UserProfileState {
  final String message;

  CheckLinkedPaymentEmoneyFailure(this.message);
}

class GetListPaymentMethodSuccess extends UserProfileState {
  final String message;
  final PaymentMethodResponse? response;

  GetListPaymentMethodSuccess(this.message, this.response);
}

class GetListPaymentMethodFailure extends UserProfileState {
  final String message;

  GetListPaymentMethodFailure(this.message);
}

class UpdateAvatarSuccess extends UserProfileState {
  final String message;

  UpdateAvatarSuccess(this.message);
}

class UpdateAvatarFailure extends UserProfileState {
  final String message;

  UpdateAvatarFailure(this.message);
}

class GenerateQRCodeFTTHCommissionSuccess extends UserProfileState {
  final String message;

  GenerateQRCodeFTTHCommissionSuccess(this.message);
}

class GenerateQRCodeFTTHCommissionFailure extends UserProfileState {
  final String message;

  GenerateQRCodeFTTHCommissionFailure(this.message);
}

class AbaCheckAbaCardSuccess extends UserProfileState {
  final String message;

  AbaCheckAbaCardSuccess(this.message);
}

class AbaCheckAbaCardFailure extends UserProfileState {
  final String message;

  AbaCheckAbaCardFailure(this.message);
}

class GetUserInfoSuccess extends UserProfileState {
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

class GetUserInfoFailure extends UserProfileState {
  final String message;

  GetUserInfoFailure(this.message);
}