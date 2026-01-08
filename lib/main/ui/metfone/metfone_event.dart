import 'package:equatable/equatable.dart';

abstract class MetfoneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MetfoneStarted extends MetfoneEvent {}

class BannerHeaderChanged extends MetfoneEvent {
  final int index;
  BannerHeaderChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class BannerFooterChanged extends MetfoneEvent {
  final int index;
  BannerFooterChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class GetAllAppsEvent extends MetfoneEvent {
  final bool isCallAPI;
  GetAllAppsEvent({this.isCallAPI = false});
}

class GetServiceByGroupAppsEvent extends MetfoneEvent {
  final String type;
  final bool isCallAPI;
  GetServiceByGroupAppsEvent(this.type, {this.isCallAPI = false});
}

class GetFTTHPackageAppsEvent extends MetfoneEvent {}
