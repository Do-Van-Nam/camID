import 'package:cam_id/main/data/model/charge_history_model.dart';
import 'package:cam_id/main/data/model/value_charging_history_model.dart';
import 'package:equatable/equatable.dart';

class ChargeHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChargeHistoryInitial extends ChargeHistoryState {}

class ChargeHistoryLoading extends ChargeHistoryState {}

class GetChargeHistorySuccess extends ChargeHistoryState {
  // final Map<String, List<ValueChargingHistoryModel>> data;
  final List<ChargeHistoryModel>? listChargingHistory;
  final List<ValueChargingHistoryModel>? listBasic;
  final List<ValueChargingHistoryModel>? listData;
  final List<ValueChargingHistoryModel>? listCall;
  final List<ValueChargingHistoryModel>? listSMS;
  final List<ValueChargingHistoryModel>? listRoaming;

  GetChargeHistorySuccess(
    this.listChargingHistory,
    this.listBasic,
    this.listData,
    this.listCall,
    this.listSMS,
    this.listRoaming,
  );
}

class GetChargeHistoryFailure extends ChargeHistoryState {
  final String message;

  GetChargeHistoryFailure(this.message);
}
