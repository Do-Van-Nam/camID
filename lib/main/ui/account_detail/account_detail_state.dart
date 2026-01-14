import 'package:cam_id/main/data/model/banner_model.dart';
import 'package:equatable/equatable.dart';

class AccountDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountDetailInitial extends AccountDetailState {}

class AccountDetailLoading extends AccountDetailState {}

class GetAccountsOcsDetailSuccess extends AccountDetailState {
  final String status;
  final String activeDue;
  final String expiredDue;
  final String suspendedDue;

  GetAccountsOcsDetailSuccess(this.status, this.activeDue, this.expiredDue, this.suspendedDue);
}

class GetAccountsOcsDetailFailure extends AccountDetailState {
  final String message;

  GetAccountsOcsDetailFailure(this.message);
}

class GetAllAppSuccess extends AccountDetailState {
  final List<String>? listActiveText;
  final List<String>? listExpired;
  final List<String>? listSuspended;
  GetAllAppSuccess(this.listActiveText, this.listExpired, this.listSuspended);
}

class GetAllAppFailure extends AccountDetailState {
  final String message;

  GetAllAppFailure(this.message);
}