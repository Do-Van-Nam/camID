class ServiceGroup {
  String? name;
  String? code;
  String? shortDes;
  String? iconUrl;
  double? price;
  int? isMultPlan;
  int? isRegisterAble;
  int? state;
  String? validity;
  String? autoRenew;
  String? currency;
  String? expired;
  String? noneAutoCode;
  String? autoCode;

  ServiceGroup();

  factory ServiceGroup.fromJson(Map<String, dynamic> json) {
    final model = ServiceGroup();
    model.name = json['name'] as String?;
    model.code = json['code'] as String?;
    model.shortDes = json['shortDes'] as String?;
    model.iconUrl = json['iconUrl'] as String?;
    model.price = (json['price'] != null)
        ? (json['price'] as num).toDouble()
        : null;
    model.isMultPlan = json['isMultPlan'] as int?;
    model.isRegisterAble = json['isRegisterAble'] as int?;
    model.state = json['state'] as int?;
    model.validity = json['validity'] as String?;
    model.autoRenew = json['autoRenew'] as String?;
    model.currency = json['currency'] as String?;
    model.expired = json['expired'] as String?;
    model.noneAutoCode = json['noneAutoCode'] as String?;
    model.autoCode = json['autoCode'] as String?;
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'shortDes': shortDes,
      'iconUrl': iconUrl,
      'price': price,
      'isMultPlan': isMultPlan,
      'isRegisterAble': isRegisterAble,
      'state': state,
      'validity': validity,
      'autoRenew': autoRenew,
      'currency': currency,
      'expired': expired,
      'noneAutoCode': noneAutoCode,
      'autoCode': autoCode,
    };
  }
}