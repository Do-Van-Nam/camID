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

  CheckLinkedPaymentEmoneySuccess(this.message);
}

class CheckLinkedPaymentEmoneyFailure extends UserProfileState {
  final String message;

  CheckLinkedPaymentEmoneyFailure(this.message);
}

class GetListPaymentMethodSuccess extends UserProfileState {
  final String message;

  GetListPaymentMethodSuccess(this.message);
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