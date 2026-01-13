import 'package:equatable/equatable.dart';

abstract class PaymentHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPaymentHistoryEvent extends PaymentHistoryEvent {

}