import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginOTPState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginOTPInitial extends LoginOTPState {}


class GenerateOTPSuccess extends LoginOTPState {
  final String message;

  GenerateOTPSuccess(this.message);
}

class GenerateOTPFailure extends LoginOTPState {
  final String message;

  GenerateOTPFailure(this.message);
}

class SignInLoading extends LoginOTPState {}

class SignInSuccess extends LoginOTPState {
  final String message;
  final SignInModel data;

  SignInSuccess(this.message, this.data);
}

class SignInFailure extends LoginOTPState {
  final String message;

  SignInFailure(this.message);
}

class GetUserInfoSuccess extends LoginOTPState {
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

class GetUserInfoFailure extends LoginOTPState {
  final String message;

  GetUserInfoFailure(this.message);
}