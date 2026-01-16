class ProvinceModel {
  String? provinceCode;
  String? provinceName;

  ProvinceModel();

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
  final model = ProvinceModel();
  model.provinceCode = json['code'] ?? '';
  model.provinceName = json['name'] ?? '';
  return model;
  }

}