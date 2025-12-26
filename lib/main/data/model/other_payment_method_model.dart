class OtherPaymentMethodModel {
  final String? name;
  final String? image;
  final String? description;
  final String? descriptionKm;
  final String? partnerCode;
  final int? partnerOrder;
  final String? featureStatus;

  OtherPaymentMethodModel({
    this.name,
    this.image,
    this.description,
    this.descriptionKm,
    this.partnerCode,
    this.partnerOrder,
    this.featureStatus,
  });

  factory OtherPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return OtherPaymentMethodModel(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      descriptionKm: json['descriptionKm'],
      partnerCode: json['partnerCode'],
      partnerOrder: json['partnerOrder'],
      featureStatus: json['featureStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'descriptionKm': descriptionKm,
      'partnerCode': partnerCode,
      'partnerOrder': partnerOrder,
      'featureStatus': featureStatus,
    };
  }
}