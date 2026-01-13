class TvSubscriberModel {
  String? actStatus;
  String? isdn;
  String? telMobile;
  String? productCode;
  int? contractId;
  int? subIdFtth;

  TvSubscriberModel();

  factory TvSubscriberModel.fromJson(Map<String, dynamic> json) {
    final model = TvSubscriberModel();
    model.actStatus = json['actStatus'] ?? '';
    model.isdn = json['isdn'] ?? '';
    model.telMobile = json['telMobile'] ?? '';
    model.productCode = json['productCode'] ?? '';
    model.contractId = json['contractId'] != null
        ? (json['contractId'] as num).toInt()
        : null;
    model.subIdFtth = json['subIdFtth'] != null
        ? (json['subIdFtth'] as num).toInt()
        : null;
    return model;
  }
}