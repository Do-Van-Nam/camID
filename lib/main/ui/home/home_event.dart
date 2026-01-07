import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class BannerChanged extends HomeEvent {
  final int index;
  BannerChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class LoginTapped extends HomeEvent {}

class GetAllAppsEvent extends HomeEvent {
  final bool isCallAPI;
  GetAllAppsEvent({this.isCallAPI = false});
}

class GetServiceByGroupAppsEvent extends HomeEvent {
  final String type;
  final bool isCallAPI;
  GetServiceByGroupAppsEvent(this.type, {this.isCallAPI = false});
}

class GetAccountsOcsDetailEvent extends HomeEvent {
}

class SignUpEvent extends HomeEvent{
  final String phoneNumber;
  final bool confirmOtp;
  final String otp;
  SignUpEvent(this.phoneNumber, this.confirmOtp, this.otp);
}

class GenerateOTPEvent extends HomeEvent {
  final String phoneNumber;

  GenerateOTPEvent(this.phoneNumber);
}

class SignInEvent extends HomeEvent {
  final String phoneNumber;
  final String otp;

  SignInEvent(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class GetUserInfoEvent extends HomeEvent {
  final String token;

  GetUserInfoEvent(this.token);
}
class ResetSignUpSuccessEvent extends HomeEvent {}
class ResetSignInSuccessEvent extends HomeEvent {}

