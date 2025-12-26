import 'package:equatable/equatable.dart';

abstract class VerifyEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class GetOTPByServiceEvent extends VerifyEvent {
  final String phone;
  final String language;
  final String service;

  GetOTPByServiceEvent(this.phone, this.language, this.service);
}

class ConfirmOTPEvent extends VerifyEvent {
  final String phone;
  final String language;
  final String service;
  final String otp;

  ConfirmOTPEvent(this.phone, this.language, this.service, this.otp);
}