// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Favorite _$FavoriteFromJson(Map<String, dynamic> json) => _Favorite(
  recipeId: (json['recipeId'] as num).toInt(),
  category: json['category'] as String,
  cachedFood: json['cachedFood'] == null
      ? null
      : Food.fromJson(json['cachedFood'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FavoriteToJson(_Favorite instance) => <String, dynamic>{
  'recipeId': instance.recipeId,
  'category': instance.category,
  'cachedFood': instance.cachedFood?.toJson(),
};
