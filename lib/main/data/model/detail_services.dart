class DetailServices {
  String? name;
  String? code;
  String? shortDes;
  String? iconUrl;
  int? isMultPlan;
  int? state;
  String? validity;
  double? price;
  String? autoRenew;
  String? currency;

  DetailServices();

  factory DetailServices.fromJson(Map<String, dynamic> json) {
    return DetailServices()
      ..name = json['name'] as String?
      ..code = json['code'] as String?
      ..shortDes = json['shortDes'] as String?
      ..iconUrl = json['iconUrl'] as String?
      ..isMultPlan = json['isMultPlan'] as int?
      ..state = json['state'] as int?
      ..validity = json['validity'] as String?
      ..price = (json['price'] != null) ? (json['price'] as num).toDouble() : null
      ..autoRenew = json['autoRenew'] as String?
      ..currency = json['currency'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'shortDes': shortDes,
      'iconUrl': iconUrl,
      'isMultPlan': isMultPlan,
      'state': state,
      'validity': validity,
      'price': price,
      'autoRenew': autoRenew,
      'currency': currency,
    };
  }
}