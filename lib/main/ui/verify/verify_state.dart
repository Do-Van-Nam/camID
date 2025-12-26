import 'package:equatable/equatable.dart';

abstract class VerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class GetOTPByServiceSuccess extends VerifyState {
  final String message;

  GetOTPByServiceSuccess(this.message);
}

class GetOTPByServiceFailure extends VerifyState {
  final String message;

  GetOTPByServiceFailure(this.message);
}

class ConfirmOTPSuccess extends VerifyState {
  final String message;

  ConfirmOTPSuccess(this.message);
}

class ConfirmOTPFailure extends VerifyState {
  final String message;

  ConfirmOTPFailure(this.message);
}