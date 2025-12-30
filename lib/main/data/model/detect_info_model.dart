import 'package:cam_id/main/data/response/detect_ocr_from_image_response.dart';

class DetectInfoModel {
  String? fullName;
  String? dob;
  String? sex;
  String? idNumber;
  String? address;
  String? expireDate;
  String? nationality;

  DetectInfoModel({
    this.fullName,
    this.dob,
    this.sex,
    this.idNumber,
    this.address,
    this.expireDate,
    this.nationality,
  });

  factory DetectInfoModel.fromJson(Map<String, dynamic> json) {
    return DetectInfoModel(
      fullName: json['fullname'] as String?,
      dob: json['dob'] as String?,
      sex: json['sex'] as String?,
      idNumber: json['idNumber'] as String?,
      address: json['address'] as String?,
      expireDate: json['expireDate'] as String?,
      nationality: json['nationality'] as String?,
    );
  }

  factory DetectInfoModel.fromOcrResponse(DetectORCResponse res) {
    return DetectInfoModel(
      fullName: res.name,
      dob: res.dobEn,
      sex: res.sexEn,
      idNumber: res.idNumber,
      address: res.provinceEn,
      expireDate: res.expireDate,
      nationality: res.nationality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'dob': dob,
      'sex': sex,
      'idNumber': idNumber,
      'address': address,
      'expireDate': expireDate,
      'nationality': nationality,
    };
  }
}