class PackageModel {
  String? name;
  String? code;
  String? shortDes;
  String? iconUrl;
  int? isMultPlan;
  int? isRegisterAble;
  int? state;
  String? validity;
  double? price;
  String? autoRenew;
  String? currency;

  PackageModel({
    this.name,
    this.code,
    this.shortDes,
    this.iconUrl,
    this.isMultPlan,
    this.isRegisterAble,
    this.state,
    this.validity,
    this.price,
    this.autoRenew,
    this.currency,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      name: json['name'] as String?,
      code: json['code'] as String?,
      shortDes: json['shortDes'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isMultPlan: json['isMultPlan'] as int?,
      isRegisterAble: json['isRegisterAble'] as int?,
      state: json['state'] as int?,
      validity: json['validity'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      autoRenew: json['autoRenew'] as String?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'shortDes': shortDes,
      'iconUrl': iconUrl,
      'isMultPlan': isMultPlan,
      'isRegisterAble': isRegisterAble,
      'state': state,
      'validity': validity,
      'price': price,
      'autoRenew': autoRenew,
      'currency': currency,
    };
  }
}