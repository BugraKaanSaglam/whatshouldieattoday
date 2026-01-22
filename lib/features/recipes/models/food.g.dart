// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodImpl _$$FoodImplFromJson(Map<String, dynamic> json) => _$FoodImpl(
      recipeId: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameTr: json['name_tr'] as String,
      ratingValue: (json['ratingValue'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt(),
      cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      cuisines: (json['cuisines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Ingredient>[],
      ingredientsTr: (json['ingredients_tr'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Ingredient>[],
      ingredientsRaw: (json['ingredientsRaw'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      ingredientsRawTr: (json['ingredients_raw_tr'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      instructionsTr: (json['instructions_tr'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      cookingMethods: (json['cookingMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      implementsList: (json['implements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      numberOfSteps: (json['numberOfSteps'] as num?)?.toInt(),
      servings: json['servings'] as String?,
      servingsTr: json['servings_tr'] as String?,
      calories: (json['calories'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      cholesterol: (json['cholesterol'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      saturatedFat: (json['saturatedFat'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
      sugar: (json['sugar'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      unsaturatedFat: (json['unsaturatedFat'] as num?)?.toDouble(),
      nutritionRaw: (json['nutrition_raw'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$FoodImplToJson(_$FoodImpl instance) =>
    <String, dynamic>{
      'id': instance.recipeId,
      'name': instance.name,
      'name_tr': instance.nameTr,
      'ratingValue': instance.ratingValue,
      'ratingCount': instance.ratingCount,
      'prepTimeMinutes': instance.prepTimeMinutes,
      'cookTimeMinutes': instance.cookTimeMinutes,
      'categories': instance.categories,
      'cuisines': instance.cuisines,
      'ingredients': instance.ingredients,
      'ingredients_tr': instance.ingredientsTr,
      'ingredientsRaw': instance.ingredientsRaw,
      'ingredients_raw_tr': instance.ingredientsRawTr,
      'instructions': instance.instructions,
      'instructions_tr': instance.instructionsTr,
      'cookingMethods': instance.cookingMethods,
      'implements': instance.implementsList,
      'numberOfSteps': instance.numberOfSteps,
      'servings': instance.servings,
      'servings_tr': instance.servingsTr,
      'calories': instance.calories,
      'carbohydrates': instance.carbohydrates,
      'cholesterol': instance.cholesterol,
      'fiber': instance.fiber,
      'protein': instance.protein,
      'saturatedFat': instance.saturatedFat,
      'sodium': instance.sodium,
      'sugar': instance.sugar,
      'fat': instance.fat,
      'unsaturatedFat': instance.unsaturatedFat,
      'nutrition_raw': instance.nutritionRaw,
      'url': instance.url,
    };
