class LinkedPaymentMethodModel {
  final String? image;
  final String? description;
  final String? linkedPaymentId;
  final String? accountPartner;
  final String? partnerCode;
  final int? paymentDefault;
  final String? linkedDate;
  final String? cardType;
  final String? linkedAt;
  final String? expiredDate;
  final String? successfulMessage;
  final String? removeMessage;
  final bool? expired;

  /// Flutter không có R.drawable → iconBasic nên để optional
  final int? iconBasic;

  LinkedPaymentMethodModel({
    this.image,
    this.description,
    this.linkedPaymentId,
    this.accountPartner,
    this.partnerCode,
    this.paymentDefault,
    this.linkedDate,
    this.cardType,
    this.linkedAt,
    this.expiredDate,
    this.successfulMessage,
    this.removeMessage,
    this.expired,
    this.iconBasic,
  });

  factory LinkedPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return LinkedPaymentMethodModel(
      image: json['image'],
      description: json['description'],
      linkedPaymentId: json['linkedPaymentId'],
      accountPartner: json['accountPartner'],
      partnerCode: json['partnerCode'],
      paymentDefault: json['paymentDefault'],
      linkedDate: json['linkedDate'],
      cardType: json['cardType'],
      linkedAt: json['linkedAt'],
      expiredDate: json['expiredDate'],
      successfulMessage: json['successfulMessage'],
      removeMessage: json['removeMessage'],
      expired: json['expired'],
      iconBasic: json['iconBasic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'description': description,
      'linkedPaymentId': linkedPaymentId,
      'accountPartner': accountPartner,
      'partnerCode': partnerCode,
      'paymentDefault': paymentDefault,
      'linkedDate': linkedDate,
      'cardType': cardType,
      'linkedAt': linkedAt,
      'expiredDate': expiredDate,
      'successfulMessage': successfulMessage,
      'removeMessage': removeMessage,
      'expired': expired,
      'iconBasic': iconBasic,
    };
  }

  bool get isDefault => paymentDefault == 1;
}