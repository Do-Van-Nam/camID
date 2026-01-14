import 'package:cam_id/main/data/model/tv_subscriber_model.dart';

class FTTHAccountModel {
  String? phoneNumber;
  String? customerName;
  String? debit;
  String? blockDate;
  String? contractIdInfor;
  String? address;
  String? contractServiceTypes;
  String? ftthName;
  String? contractPoint;
  String? level;
  String? packageMonth;
  String? transferCurrency;
  String? monthlyPrice;
  TvSubscriberModel? tvSubscriber;
  String? ftthNameCamID;

  FTTHAccountModel();

  factory FTTHAccountModel.fromJson(Map<String, dynamic> json) {
    final model = FTTHAccountModel();
    model.phoneNumber = json['phoneNumber'] ?? '';
    model.customerName = json['customerName'] ?? '';
    model.debit = json['debit'] ?? '';
    model.blockDate = json['blockDate'] ?? '';
    model.contractIdInfor = json['contractIdInfor'] ?? '';
    model.address = json['address'] ?? '';
    model.contractServiceTypes = json['contractServiceTypes'] ?? '';
    model.ftthName = json['ftthName'] ?? '';
    model.contractPoint = json['contractPoint'] ?? '';
    model.level = json['level'] ?? '';
    model.packageMonth = json['packageMonth'] ?? '';
    model.transferCurrency = json['transferCurrency'] ?? '';
    model.monthlyPrice = json['monthlyPrice'] ?? '';
    model.tvSubscriber = json['tvSubscriber'] != null
        ? TvSubscriberModel.fromJson(json['tvSubscriber'])
        : null;
    model.ftthNameCamID = json['ftthNameCamID'] ?? '';
    return model;
  }
}
