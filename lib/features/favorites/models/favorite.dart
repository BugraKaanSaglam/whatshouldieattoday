import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required int recipeId,
    required String category,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite.fromJson(map);
}

extension FavoriteMapping on Favorite {
  Map<String, dynamic> toMap() => toJson();
}
