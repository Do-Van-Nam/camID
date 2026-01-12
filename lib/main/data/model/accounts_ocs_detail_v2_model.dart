import 'package:cam_id/main/data/model/value_account_model.dart';

class AccountsOcsDetailV2Model{
  String? type;
  double? value;
  String? exp;
  List<Value>? values;

  AccountsOcsDetailV2Model();

  factory AccountsOcsDetailV2Model.fromJson(Map<String, dynamic> json) {
    final model = AccountsOcsDetailV2Model();
    model.type = json['type'] ?? '';
    model.value = (json['value'] != null)
        ? (json['value'] as num).toDouble()
        : null;
    model.exp = json['exp'] ?? '';
    model.values = (json['values'] as List<dynamic>?)
        ?.map((e) => Value.fromJson(e))
        .toList();
    return model;
  }
}
