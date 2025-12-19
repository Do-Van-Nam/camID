import 'package:cam_id/main/data/model/phone_linked_info_model.dart';

class ServiceModel {
  int? serviceId;
  String? serviceCode;
  String? serviceName;
  List<PhoneLinkedInfoModel>? phoneLinkedList;

  ServiceModel();

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final model = ServiceModel();
    model.serviceId = json['service_id'] ?? -1;
    model.serviceCode = json['service_code'] ?? "";
    model.serviceName = json['service_name'] ?? "";
    model.phoneLinkedList = (json['phone_linked'] as List<dynamic>?)
        !.map((e) => PhoneLinkedInfoModel.fromJson(e))
        .toList();
    return model;
  }
}