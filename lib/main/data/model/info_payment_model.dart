class InfoPayment {
  String? question;
  String? topupNumber;
  String? amount;
  String? autoRenew;

  String? questionCancel;
  String? service;
  String? originalService;
  String? phoneNumber;
  String? amountCancel;
  String? contentWarning;

  InfoPayment({
    this.question,
    this.topupNumber,
    this.amount,
    this.autoRenew,
    this.questionCancel,
    this.service,
    this.originalService,
    this.phoneNumber,
    this.amountCancel,
    this.contentWarning,
  });

  factory InfoPayment.fromJson(Map<String, dynamic> json) => InfoPayment(
    question: json['question'] as String?,
    topupNumber: json['topupNumber'] as String?,
    amount: json['amount'] as String?,
    autoRenew: json['autoRenew'] as String?,
    questionCancel: json['questionCancel'] as String?,
    service: json['service'] as String?,
    originalService: json['originalService'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    amountCancel: json['amountCancel'] as String?,
    contentWarning: json['contentWarning'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'topupNumber': topupNumber,
    'amount': amount,
    'autoRenew': autoRenew,
    'questionCancel': questionCancel,
    'service': service,
    'originalService': originalService,
    'phoneNumber': phoneNumber,
    'amountCancel': amountCancel,
    'contentWarning': contentWarning,
  };
}