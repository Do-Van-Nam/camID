import 'package:equatable/equatable.dart';

abstract class ChargeHistoryDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChargeHistoryDetailEvent extends ChargeHistoryDetailEvent {
  final int  startTime;
  final String type;
  final String subType;

  GetChargeHistoryDetailEvent(this.startTime, this.type, this.subType);
}