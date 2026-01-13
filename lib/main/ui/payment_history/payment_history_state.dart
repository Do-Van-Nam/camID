import 'package:cam_id/main/data/model/auto_renew_model.dart';
import 'package:cam_id/main/data/model/payment_history_model.dart';
import 'package:equatable/equatable.dart';

class PaymentHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentHistoryInitial extends PaymentHistoryState {}

class PaymentHistoryLoading extends PaymentHistoryState {}
class AutoRenewHistoryLoading extends PaymentHistoryState {}

class GetPaymentHistorySuccess extends PaymentHistoryState {
  final List<PaymentHistoryModel>? listPayment;

  GetPaymentHistorySuccess(this.listPayment);
}

class GetPaymentHistoryFailure extends PaymentHistoryState {
  final String message;

  GetPaymentHistoryFailure(this.message);
}

class GetAutoRenewSuccess extends PaymentHistoryState {
  final List<AutoRenewModel>? listAutoRenew;

  GetAutoRenewSuccess(this.listAutoRenew);
}

class GetAutoRenewFailure extends PaymentHistoryState {
  final String message;

  GetAutoRenewFailure(this.message);
}