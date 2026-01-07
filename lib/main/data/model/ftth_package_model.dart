class PackageFtthModel {
  int? id;
  String? code;
  int? payAdvance;
  int? speed;
  String? price;
  String? name;
  String? installation;
  String? deposit;
  String? modemWifi;
  String? promotion;
  String? description;
  String? subDescription;
  String? packageType;
  String? language;

  PackageFtthModel({
    this.id,
    this.code,
    this.payAdvance,
    this.speed,
    this.price,
    this.name,
    this.installation,
    this.deposit,
    this.modemWifi,
    this.promotion,
    this.description,
    this.subDescription,
    this.packageType,
    this.language,
  });

  factory PackageFtthModel.fromJson(Map<String, dynamic> json) {
    return PackageFtthModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      payAdvance: json['payAdvance'] as int?,
      speed: json['speed'] as int?,
      price: json['price'] as String?,
      name: json['name'] as String?,
      installation: json['installation'] as String?,
      deposit: json['deposit'] as String?,
      modemWifi: json['modemWifi'] as String?,
      promotion: json['promotion'] as String?,
      description: json['description'] as String?,
      subDescription: json['subDescription'] as String?,
      packageType: json['packageType'] as String?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'payAdvance': payAdvance,
      'speed': speed,
      'price': price,
      'name': name,
      'installation': installation,
      'deposit': deposit,
      'modemWifi': modemWifi,
      'promotion': promotion,
      'description': description,
      'subDescription': subDescription,
      'packageType': packageType,
      'language': language,
    };
  }
}
