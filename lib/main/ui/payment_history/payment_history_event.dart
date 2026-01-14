import 'package:equatable/equatable.dart';

abstract class PaymentHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPaymentHistoryEvent extends PaymentHistoryEvent {
  final String fromDate;
  final String toDate;
  final int page;
  final int pageSize;

  GetPaymentHistoryEvent(this.fromDate, this.toDate, this.page, this.pageSize);
}

class GetAutoRenewHistoryEvent extends PaymentHistoryEvent {
  final String fromDate;
  final String toDate;
  final String filter;
  final int page;
  final int pageSize;

  GetAutoRenewHistoryEvent(this.fromDate, this.toDate,this.filter, this.page, this.pageSize, );
}

class CancelAutoRenewEvent extends PaymentHistoryEvent {
  final String autoRenewId;

  CancelAutoRenewEvent(this.autoRenewId);

}

class SaveAutoRenewEvent extends PaymentHistoryEvent {
  final String autoRenewId;

  SaveAutoRenewEvent(this.autoRenewId);

}