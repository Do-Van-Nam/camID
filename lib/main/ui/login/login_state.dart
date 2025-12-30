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