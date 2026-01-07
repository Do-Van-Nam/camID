class AdsModel {
  String? adImgUrl;
  String? sourceLink;
  String? orderBy;
  int? type;
  String? des;
  String? objData1;

  AdsModel({
    this.adImgUrl,
    this.sourceLink,
    this.orderBy,
    this.type,
    this.des,
    this.objData1,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      adImgUrl: json['adImgUrl'] as String?,
      sourceLink: json['sourceLink'] as String?,
      orderBy: json['orderBy'] as String?,
      type: json['type'] as int?,
      des: json['des'] as String?,
      objData1: json['objData1'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adImgUrl': adImgUrl,
      'sourceLink': sourceLink,
      'orderBy': orderBy,
      'type': type,
      'des': des,
      'objData1': objData1,
    };
  }
}