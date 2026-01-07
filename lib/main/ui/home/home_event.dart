import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class BannerChanged extends HomeEvent {
  final int index;
  BannerChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class LoginTapped extends HomeEvent {}

class GetAllAppsEvent extends HomeEvent {
  final bool isCallAPI;
  GetAllAppsEvent({this.isCallAPI = false});
}

class GetServiceByGroupAppsEvent extends HomeEvent {
  final String type;
  final bool isCallAPI;
  GetServiceByGroupAppsEvent(this.type, {this.isCallAPI = false});
}
