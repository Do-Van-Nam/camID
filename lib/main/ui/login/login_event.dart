import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends LoginEvent{
  final String phoneNumber;
  final bool confirmOtp;
  final String otp;
  SignUpEvent(this.phoneNumber, this.confirmOtp, this.otp);
}

class GenerateOTPEvent extends LoginEvent {
  final String phoneNumber;

  GenerateOTPEvent(this.phoneNumber);
}

class SignInEvent extends LoginEvent {
  final String phoneNumber;
  final String otp;

  SignInEvent(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}