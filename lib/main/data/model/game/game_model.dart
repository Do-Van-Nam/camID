class GameModel {
  final int? categoryId;
  final String? categoryName;
  final String? categoryNameKm;
  final int? id;
  final String? name;
  final String? link;
  final String? description;
  final int? visible;
  final int? order;
  final String? status;
  final int? recommend;
  final String? bannerUrl;
  final String? nameKm;
  final String? createdDate;
  final String? updatedDate;
  final String? iconUrl;

  GameModel({
    this.categoryId,
    this.categoryName,
    this.categoryNameKm,
    this.id,
    this.name,
    this.link,
    this.description,
    this.visible,
    this.order,
    this.status,
    this.recommend,
    this.bannerUrl,
    this.nameKm,
    this.createdDate,
    this.updatedDate,
    this.iconUrl,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      categoryId: json['categoryId'] as int?,
      categoryName: json['categoryName'] as String?,
      categoryNameKm: json['categoryNameKm'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      link: json['link'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as int?,
      order: json['order'] as int?,
      status: json['status'] as String?,
      recommend: json['recommend'] as int?,
      bannerUrl: json['bannerUrl'] as String?,
      nameKm: json['name_km'] as String?,
      createdDate: json['created_date'] as String?,
      updatedDate: json['updated_date'] as String?,
      iconUrl: json['icon_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryNameKm': categoryNameKm,
      'id': id,
      'name': name,
      'link': link,
      'description': description,
      'visible': visible,
      'order': order,
      'status': status,
      'recommend': recommend,
      'bannerUrl': bannerUrl,
      'name_km': nameKm,
      'created_date': createdDate,
      'updated_date': updatedDate,
      'icon_url': iconUrl,
    };
  }
}
