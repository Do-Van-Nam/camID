import 'game_model.dart';

class CategoryItem {
  final int? id;
  final String? status;
  final List<GameModel>? games;
  final String? name;
  final String? nameKm;

  CategoryItem({this.id, this.status, this.games, this.name, this.nameKm});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as int?,
      status: json['status'] as String?,
      games: (json['games'] as List<dynamic>?)
          ?.map((e) => GameModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      nameKm: json['name_km'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'games': games?.map((e) => e.toJson()).toList(),
      'name': name,
      'name_km': nameKm,
    };
  }
}
