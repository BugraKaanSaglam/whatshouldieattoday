import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    @JsonKey(name: 'Ingredient') required String name,
    @JsonKey(name: 'Ingredient_tr') @Default('') String nameTr,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  factory Ingredient.fromMap(Map<String, dynamic> map) => Ingredient.fromJson(map);
}

extension IngredientMapping on Ingredient {
  Map<String, dynamic> toMap() => toJson();
}
