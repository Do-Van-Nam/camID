import 'category_model.dart';

class GameData {
  final List<CategoryItem> items;
  final int total;
  final String? categoryNameShow;

  GameData({required this.items, required this.total, this.categoryNameShow});

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      items: (json['items'] as List<dynamic>)
          .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      categoryNameShow: json['categoryNameShow'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'categoryNameShow': categoryNameShow,
    };
  }
}
