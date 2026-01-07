class AppModel {
  String? id;
  String? name;
  String? shortDes;
  dynamic fullDes;
  String? iconUrl;
  String? iosLink;
  String? androidLink;

  AppModel({
    this.id,
    this.name,
    this.shortDes,
    this.fullDes,
    this.iconUrl,
    this.iosLink,
    this.androidLink,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      shortDes: json['shortDes'] as String?,
      fullDes: json['fullDes'],
      iconUrl: json['iconUrl'] as String?,
      iosLink: json['iosLink'] as String?,
      androidLink: json['androidLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortDes': shortDes,
      'fullDes': fullDes,
      'iconUrl': iconUrl,
      'iosLink': iosLink,
      'androidLink': androidLink,
    };
  }
}