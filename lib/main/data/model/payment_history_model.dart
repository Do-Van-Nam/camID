class PaymentHistoryModel {
  String? paymentDate;
  String? paymentTime;
  List<HistoryPerDay>? historyPerDayList;

  PaymentHistoryModel();

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    final model = PaymentHistoryModel();
    model.paymentDate = json['paymentDate'] ?? '';
    model.paymentTime = json['paymentTime'] ?? '';
    model.historyPerDayList = (json['historyPerDay'] as List<dynamic>?)
        ?.map((e) => HistoryPerDay.fromJson(e))
        .toList();
    return model;
  }

  Map<String, dynamic> toJson() => {
    'paymentDate': paymentDate,
    'paymentTime': paymentTime,
    'historyPerDay': historyPerDayList?.map((e) => e.toJson()).toList(),
  };
}

class HistoryPerDay {
  String? id;
  String? service;
  String? method;
  String? image;
  String? amount;
  String? content;
  String? paymentTime;
  String? receiveIsdn;
  String? partnerAccount;

  HistoryPerDay();

  factory HistoryPerDay.fromJson(Map<String, dynamic> json) {
    final model = HistoryPerDay();
    model.id = json['id'] ?? '';
    model.service = json['service'] ?? '';
    model.method = json['method'] ?? '';
    model.image = json['image'] ?? '';
    model.amount = json['amount'] ?? '';
    model.content = json['content'] ?? '';
    model.paymentTime = json['paymentTime'] ?? '';
    model.receiveIsdn = json['receiveIsdn'] ?? '';
    model.partnerAccount = json['partnerAccount'] ?? '';
    return model;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'service': service,
    'method': method,
    'image': image,
    'amount': amount,
    'content': content,
    'paymentTime': paymentTime,
    'receiveIsdn': receiveIsdn,
    'partnerAccount': partnerAccount,
  };
}
