import 'package:cam_id/main/data/model/value_charging_history_model.dart';

class ChargeHistoryModel {
  String? type;
  double? value;
  double? duration;
  String? exp;
  List<ValueChargingHistoryModel>? values;

  ChargeHistoryModel();

  factory ChargeHistoryModel.fromJson(Map<String, dynamic> json) {
    final model = ChargeHistoryModel();
    model.type = json['type'] ?? '';
    model.value = (json['value'] != null)
        ? (json['value'] as num).toDouble()
        : null;
    model.duration = (json['duration'] != null)
        ? (json['duration'] as num).toDouble()
        : null;
    model.exp = json['exp'] ?? '';
    model.values = (json['values'] as List<dynamic>?)
        ?.map((e) => ValueChargingHistoryModel.fromJson(e))
        .toList();
    return model;
  }
}