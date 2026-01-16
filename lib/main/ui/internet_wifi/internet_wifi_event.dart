import 'package:equatable/equatable.dart';

abstract class InternetWifiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFTTHAccountEvent extends InternetWifiEvent {}

class GetFTTHPackageAppsEvent extends InternetWifiEvent {}
class GetAllAppsEvent extends InternetWifiEvent {
  final bool isCallAPI;
  GetAllAppsEvent({this.isCallAPI = false});
}

class SendIDFTTHEvent extends InternetWifiEvent {
  final String idFTTH;
  SendIDFTTHEvent(this.idFTTH);
}

class SearchFTTHAccountByPhoneEvent extends InternetWifiEvent {
  final String phoneNumber;
  SearchFTTHAccountByPhoneEvent(this.phoneNumber);
}
