import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitLinkedPaymentEvent extends UserProfileEvent {

}

class CheckLinkedPaymentEmoneyEvent extends UserProfileEvent {
  final String camId;
  final String isdn;
  final String language;

  CheckLinkedPaymentEmoneyEvent(this.camId, this.isdn, this.language);
}

class GetListPaymentMethodEvent extends UserProfileEvent {
  final String camId;
  final String service;
  final String language;

  GetListPaymentMethodEvent(this.camId, this.service, this.language);
}

class UpdateAvatarEvent extends UserProfileEvent {

}

class GenerateQRCodeFTTHCommissionEvent extends UserProfileEvent {

}

class AbaCheckAbaCardEvent extends UserProfileEvent {

}

class GetUserInfoEvent extends UserProfileEvent {
  final String token;

  GetUserInfoEvent(this.token);
}