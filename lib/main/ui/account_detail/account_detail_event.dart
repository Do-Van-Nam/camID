import 'package:equatable/equatable.dart';

abstract class AccountDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAccountsOcsDetailEvent extends AccountDetailEvent {

}

class GetAllAppsEvent extends AccountDetailEvent {
  final bool isCallAPI;
  GetAllAppsEvent({this.isCallAPI = false});
}