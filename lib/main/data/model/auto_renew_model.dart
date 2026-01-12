class AutoRenewModel {
  String? paymentDate;
  List<AutoRenewHistoryPerDay>? historyPerDayList;

  AutoRenewModel();

  factory AutoRenewModel.fromJson(Map<String, dynamic> json) {
    final model = AutoRenewModel();
    model.paymentDate = json['paymentDate'] ?? '';
    if (json['historyPerDay'] != null) {
      model.historyPerDayList = (json['historyPerDay'] as List)
          .map((e) => AutoRenewHistoryPerDay.fromJson(e))
          .toList();
    } else {
      model.historyPerDayList = [];
    }
    return model;
  }

  Map<String, dynamic> toJson() => {
    'paymentDate': paymentDate,
    'historyPerDay':
    historyPerDayList?.map((e) => e.toJson()).toList() ?? [],
  };
}

class AutoRenewHistoryPerDay {
  static const int statusOn = 0;
  static const int statusOff = 1;

  String? id;
  String? service;
  String? image;
  String? amount;
  String? content;
  int? status;
  int? createDate;
  String? accountNumber;
  String? accountPartner;
  String? formatDate;
  String? linkedDate;
  String? linkedPaymentId;
  String? cancelConfirmMessage;
  String? expiredIn;
  String? originalService;

  AutoRenewHistoryPerDay();

  factory AutoRenewHistoryPerDay.fromJson(Map<String, dynamic> json) {
    final model = AutoRenewHistoryPerDay();
    model.id = json['id'] ?? '';
    model.service = json['service'] ?? '';
    model.image = json['image'] ?? '';
    model.amount = json['amount'] ?? '';
    model.content = json['content'] ?? '';
    model.status = json['status'];
    model.createDate = json['createDate'];
    model.accountNumber = json['accountNumber'] ?? '';
    model.accountPartner = json['accountPartner'] ?? '';
    model.formatDate = json['formatDate'] ?? '';
    model.linkedDate = json['linkedDate'] ?? '';
    model.linkedPaymentId = json['linkedPaymentId'] ?? '';
    model.cancelConfirmMessage = json['cancelConfirmMessage'] ?? '';
    model.expiredIn = json['expiredIn'] ?? '';
    model.originalService = json['originalService'] ?? '';
    return model;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'service': service,
    'image': image,
    'amount': amount,
    'content': content,
    'status': status,
    'createDate': createDate,
    'accountNumber': accountNumber,
    'accountPartner': accountPartner,
    'formatDate': formatDate,
    'linkedDate': linkedDate,
    'linkedPaymentId': linkedPaymentId,
    'cancelConfirmMessage': cancelConfirmMessage,
    'expiredIn': expiredIn,
    'originalService': originalService,
  };
}