import 'package:equatable/equatable.dart';

abstract class RegisterFtthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetListProvinceEvent extends RegisterFtthEvent {}

class GenerateOTPFTTHEvent extends RegisterFtthEvent {
  final String phoneNumber;

  GenerateOTPFTTHEvent(this.phoneNumber);
}