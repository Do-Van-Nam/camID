class PhoneLinkedInfoModel {
  int? userServiceId;
  String? phoneNumber;
  String? status;
  int? metfonePlus;
  bool? isSelect;

  PhoneLinkedInfoModel();

  factory PhoneLinkedInfoModel.fromJson(Map<String, dynamic> json) {
    return PhoneLinkedInfoModel()
      ..userServiceId = json['user_service_id'] as int?
      ..phoneNumber = json['phone_number']?.toString() ?? ""
      ..status = json['status']?.toString() ?? ""
      ..metfonePlus = json['metfonePlus'] as int? ?? -1
      ..isSelect = false;
  }
}
