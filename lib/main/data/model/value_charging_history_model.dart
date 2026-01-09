import 'package:cam_id/main/data/model/value_child_charging_history_model.dart';

class ValueChargingHistoryModel {
  String? day;
  double? total;
  int? duration;
  List<ValueChildChargingHistoryModel>? valuesChild;

  ValueChargingHistoryModel();

  factory ValueChargingHistoryModel.fromJson(Map<String, dynamic> json) {
    final model = ValueChargingHistoryModel();
    model.day = json['day'] ?? '';
    model.total = (json['total'] != null)
        ? (json['total'] as num).toDouble()
        : null;
    model.duration = json['duration'] as int?;
    model.valuesChild = (json['values'] as List<dynamic>?)
        ?.map((e) => ValueChildChargingHistoryModel.fromJson(e))
        .toList();
    return model;
  }
}