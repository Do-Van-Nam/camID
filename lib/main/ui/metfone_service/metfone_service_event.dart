import 'package:equatable/equatable.dart';

abstract class MetfoneServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetServiceForYouEvent extends MetfoneServiceEvent {}

class GetMyServicesEvent extends MetfoneServiceEvent {}

class DoActionServiceEvent extends MetfoneServiceEvent {
  final String serviceCode;
  final String serviceCodeCheck;
  final String mNameService;
  final String mContentServiceRegisterDialog;
  final int serviceType;
  final String price;
  DoActionServiceEvent(
    this.serviceCode,
    this.serviceCodeCheck,
    this.mNameService,
    this.mContentServiceRegisterDialog,
    this.serviceType,
    this.price,
  );
}

class StopActionServiceEvent extends MetfoneServiceEvent {
  final String serviceCode;

  StopActionServiceEvent(this.serviceCode);
}
