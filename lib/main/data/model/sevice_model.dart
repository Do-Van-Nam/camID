import 'package:cam_id/main/data/model/phone_linked_info_model.dart';

class ServiceModel {
  int? serviceId;
  String? serviceCode;
  String? serviceName;
  List<PhoneLinkedInfoModel>? phoneLinkedList;

  void fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'] ?? -1;
    serviceCode = json['service_code'] ?? "";
    serviceName = json['service_name'] ?? "";
    phoneLinkedList = (json['phone_linked'] as List<dynamic>?)
        ?.map((e) => PhoneLinkedInfoModel()..fromJson(e))
        .toList()
        ?? [];
  }

}