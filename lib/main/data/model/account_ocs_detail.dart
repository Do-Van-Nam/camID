import 'package:cam_id/main/data/model/account_ocs_value.dart';

class AccountOcsDetail {
  String? title;
  List<AccountOcsValue>? values;

  AccountOcsDetail();

  factory AccountOcsDetail.fromJson(Map<String, dynamic> json) {
    final model = AccountOcsDetail();
    model.title = json['title'] ?? '';
    model.values = (json['values'] as List<dynamic>?)
        ?.map((e) => AccountOcsValue.fromJson(e))
        .toList();
    return model;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'values': values?.map((e) => e.toJson()).toList(),
  };
}