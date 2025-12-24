import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitLinkedPaymentEvent extends UserProfileEvent {

}

class CheckLinkedPaymentEmoneyEvent extends UserProfileEvent {

}

class GetListPaymentMethodEvent extends UserProfileEvent {

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