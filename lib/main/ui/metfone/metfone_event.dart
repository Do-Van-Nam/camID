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

class GetAllAppsEvent extends MetfoneEvent {}

class GetServiceByGroupAppsEvent extends MetfoneEvent {
  final String type;

  GetServiceByGroupAppsEvent(this.type);
}

class GetFTTHPackageAppsEvent extends MetfoneEvent {}
