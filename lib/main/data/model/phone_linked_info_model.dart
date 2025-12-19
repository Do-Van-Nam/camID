class PhoneLinkedInfoModel {
  int? userServiceId;
  String? phoneNumber;
  String? status;
  int? metfonePlus;
  bool? isSelect;

  void fromJson(Map<String, dynamic> json) {
    userServiceId = json['user_service_id'];
    phoneNumber = json['phone_number'] ?? "";
    status = json['status'] ?? "";
    metfonePlus = json['metfonePlus'] ?? -1;
  }
}