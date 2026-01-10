import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';
import 'package:equatable/equatable.dart';

class ChargeHistoryDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChargeHistoryDetailInitial extends ChargeHistoryDetailState {}

class ChargeHistoryDetailLoading extends ChargeHistoryDetailState {}

class GetChargeHistoryDetailSuccess extends ChargeHistoryDetailState {
  final List<ValueChildChargingHistoryModel>? listAll;
  final List<ValueChildChargingHistoryModel>? listCall;
  final List<ValueChildChargingHistoryModel>? listData;
  final List<ValueChildChargingHistoryModel>? listSMS;
  final List<ValueChildChargingHistoryModel>? listService;

  GetChargeHistoryDetailSuccess(this.listAll, this.listCall, this.listData, this.listSMS, this.listService);
}

class GetChargeHistoryDetailFailure extends ChargeHistoryDetailState {
  final String message;

  GetChargeHistoryDetailFailure(this.message);
}