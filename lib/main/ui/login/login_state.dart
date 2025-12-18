import 'package:cam_id/main/data/model/image_kyc_model.dart';
import 'package:cam_id/main/data/model/sevice_model.dart';
import 'package:cam_id/main/data/model/sign_in_model.dart';
import 'package:cam_id/main/data/model/user_info_model.dart';
import 'package:cam_id/main/data/response/sign_in_response.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class SignUpLoading extends LoginState {}

class SignUpSuccess extends LoginState {
  final String message;

  SignUpSuccess(this.message);
}

class SignUpFailure extends LoginState {
  final String message;

  SignUpFailure(this.message);
}

class GenerateOTPSuccess extends LoginState {
  final String message;

  GenerateOTPSuccess(this.message);
}

class GenerateOTPFailure extends LoginState {
  final String message;

  GenerateOTPFailure(this.message);
}

class SignInLoading extends LoginState {}

class SignInSuccess extends LoginState {
  final String message;
  final SignInModel data;

  SignInSuccess(this.message, this.data);
}

class SignInFailure extends LoginState {
  final String message;

  SignInFailure(this.message);
}

class GetUserInfoSuccess extends LoginState {
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

class GetUserInfoFailure extends LoginState {
  final String message;

  GetUserInfoFailure(this.message);
}
