import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
abstract class Favorite with _$Favorite {
  @JsonSerializable(explicitToJson: true)
  const factory Favorite({
    required int recipeId,
    required String category,
    Food? cachedFood,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite.fromJson(map);
}

extension FavoriteMapping on Favorite {
  Map<String, dynamic> toMap() => toJson();
}
