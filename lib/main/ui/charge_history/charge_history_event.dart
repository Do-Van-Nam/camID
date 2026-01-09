import 'dart:ffi';

import 'package:equatable/equatable.dart';

abstract class ChargeHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChargeHistoryEvent extends ChargeHistoryEvent {
  final int  startTime;
  final String type;

  GetChargeHistoryEvent(this.startTime, this.type);
}
