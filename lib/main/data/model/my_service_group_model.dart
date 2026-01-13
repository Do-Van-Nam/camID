import 'detail_services.dart';

class MyServiceGroup {
  String? groupName;
  String? groupCode;
  List<DetailServices>? services;

  MyServiceGroup();

  factory MyServiceGroup.fromJson(Map<String, dynamic> json) {
    final model = MyServiceGroup();
    model.groupName = json['groupName'] as String?;
    model.groupCode = json['groupCode'] as String?;
    model.services = (json['services'] as List<dynamic>?)
        ?.map((e) => DetailServices.fromJson(e))
        .toList();
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'groupCode': groupCode,
      'services': services?.map((e) => e.toJson()).toList(),
    };
  }
}
