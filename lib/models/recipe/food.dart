// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yemek_tarifi_app/enums/categories_enum.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';

part 'food.freezed.dart';
part 'food.g.dart';

@freezed
class Food with _$Food {
  const Food._();

  const factory Food({
    @JsonKey(name: 'id') required int recipeId,
    required String name,
    @JsonKey(name: 'name_tr') required String nameTr,
    double? ratingValue,
    int? ratingCount,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    @Default(<String>[]) List<String> categories,
    @Default(<String>[]) List<String> cuisines,
    @Default(<Ingredient>[]) List<Ingredient> ingredients,
    @JsonKey(name: 'ingredients_tr') @Default(<Ingredient>[]) List<Ingredient> ingredientsTr,
    @Default(<String>[]) List<String> ingredientsRaw,
    @JsonKey(name: 'ingredients_raw_tr') @Default(<String>[]) List<String> ingredientsRawTr,
    @Default(<String>[]) List<String> instructions,
    @JsonKey(name: 'instructions_tr') @Default(<String>[]) List<String> instructionsTr,
    @Default(<String>[]) List<String> cookingMethods,
    @JsonKey(name: 'implements') @Default(<String>[]) List<String> implementsList,
    int? numberOfSteps,
    String? servings,
    @JsonKey(name: 'servings_tr') String? servingsTr,
    double? calories,
    double? carbohydrates,
    double? cholesterol,
    double? fiber,
    double? protein,
    double? saturatedFat,
    double? sodium,
    double? sugar,
    double? fat,
    double? unsaturatedFat,
    @JsonKey(name: 'nutrition_raw') @Default(<String, String>{}) Map<String, String> nutritionRaw,
    String? url,
    @JsonKey(includeFromJson: false, includeToJson: false) @Default(CategoriesEnum.none) CategoriesEnum recipeCategory,
  }) = _Food;

  int? get totalTimeMinutes {
    if (prepTimeMinutes == null && cookTimeMinutes == null) return null;
    return (prepTimeMinutes ?? 0) + (cookTimeMinutes ?? 0);
  }

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  factory Food.fromMap(Map<String, dynamic> map) {
    // ID (CSV: "Id", eski dataset: "RecipeId", Supabase: "id")
    final dynamic idRaw = map['id'] ?? map['Id'] ?? map['RecipeId'];
    final int recipeId = _parseInt(idRaw) ?? 0;

    final String name = (map['name'] ?? map['Name'] ?? '').toString().trim();
    final String nameTr = (map['name_tr'] ?? map['Name_tr'] ?? name).toString().trim();

    // Rating
    final double? ratingValue = _parseNumeric(map['rating_value'] ?? map['Rating Value']);
    final int? ratingCount = _parseInt(map['rating_count'] ?? map['Rating Count']);

    // Zaman
    final int? prepTimeMinutes = _parseInt(map['prep_time'] ?? map['Preparation Time']);
    final int? cookTimeMinutes = _parseInt(map['cook_time'] ?? map['Cooking Time']);

    // Category / Cuisine
    final List<String> categories = _parseStringList(map['category'] ?? map['Category']);
    final List<String> cuisines = _parseStringList(map['cuisine'] ?? map['Cuisine']);

    // Ingredients (structured)
    final List<Ingredient> ingredients = _buildIngredientList(
      map['ingredients'] ?? map['Ingredients'],
      map['ingredients_tr'] ?? map['Ingredients_tr'],
    );

    final List<Ingredient> ingredientsTr = _buildIngredientList(
      map['ingredients_tr'] ?? map['Ingredients_tr'],
      map['ingredients_tr'] ?? map['Ingredients_tr'],
    );

    // Ingredients raw
    final List<String> ingredientsRaw = _parseStringList(map['ingredients_raw'] ?? map['Ingredients_Raw']);
    final List<String> ingredientsRawTr = _parseStringList(map['ingredients_raw_tr'] ?? map['Ingredients_Raw_tr']);

    // Instructions
    final List<String> instructions = _parseStringList(map['instructions'] ?? map['Instructions']);
    final List<String> instructionsTr = _parseStringList(map['instructions_tr'] ?? map['Instructions_tr']);

    // Cooking methods / Implements
    final List<String> cookingMethods = _parseStringList(map['cooking_methods'] ?? map['Cooking Methods']);
    final List<String> implementsList = _parseStringList(map['implements'] ?? map['Implements']);

    // Steps
    final int? numberOfSteps = _parseInt(map['number_of_steps'] ?? map['Number of steps']);

    // Servings
    final String? servings = (map['servings'] ?? map['Servings'])?.toString();
    final String? servingsTr = (map['servings_tr'] ?? map['Servings_tr'])?.toString();

    // Nutrition
    final Map<String, String> nutritionRaw = _parseNutritionText(map['nutrition_raw'] ?? map['Nutrition']);

    final double? calories = _parseNumeric(map['calories'] ?? nutritionRaw['Calories']);
    final double? carbohydrates = _parseNumeric(map['carbohydrates'] ?? nutritionRaw['Carbohydrates']);
    final double? cholesterol = _parseNumeric(map['cholesterol'] ?? nutritionRaw['Cholesterol']);
    final double? fiber = _parseNumeric(map['fiber'] ?? nutritionRaw['Fiber']);
    final double? protein = _parseNumeric(map['protein'] ?? nutritionRaw['Protein']);
    final double? saturatedFat = _parseNumeric(map['saturated_fat'] ?? nutritionRaw['Saturated Fat']);
    final double? sodium = _parseNumeric(map['sodium'] ?? nutritionRaw['Sodium']);
    final double? sugar = _parseNumeric(map['sugar'] ?? nutritionRaw['Sugar']);
    final double? fat = _parseNumeric(map['fat'] ?? nutritionRaw['Fat']);
    final double? unsaturatedFat = _parseNumeric(map['unsaturated_fat'] ?? nutritionRaw['Unsaturated Fat']);

    final String? url = (map['url'] ?? map['URL'])?.toString();

    final CategoriesEnum? catEnum = _parseCategoryEnum(categories);

    return Food(
      recipeId: recipeId,
      name: name,
      nameTr: nameTr,
      ratingValue: ratingValue,
      ratingCount: ratingCount,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      categories: categories,
      cuisines: cuisines,
      ingredients: ingredients,
      ingredientsTr: ingredientsTr,
      ingredientsRaw: ingredientsRaw,
      ingredientsRawTr: ingredientsRawTr,
      instructions: instructions,
      instructionsTr: instructionsTr,
      cookingMethods: cookingMethods,
      implementsList: implementsList,
      numberOfSteps: numberOfSteps,
      servings: servings,
      servingsTr: servingsTr,
      calories: calories,
      carbohydrates: carbohydrates,
      cholesterol: cholesterol,
      fiber: fiber,
      protein: protein,
      saturatedFat: saturatedFat,
      sodium: sodium,
      sugar: sugar,
      fat: fat,
      unsaturatedFat: unsaturatedFat,
      nutritionRaw: nutritionRaw,
      url: url,
      recipeCategory: catEnum ?? CategoriesEnum.none,
    );
  }

  /// Supabase için map (snake_case kolon isimleri)
  Map<String, dynamic> toMap() {
    return {
      'id': recipeId,
      'name': name,
      'name_tr': nameTr,
      'rating_value': ratingValue,
      'rating_count': ratingCount,
      'prep_time': prepTimeMinutes,
      'cook_time': cookTimeMinutes,
      'category': categories,
      'cuisine': cuisines,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'ingredients_tr': ingredientsTr.map((e) => e.toMap()).toList(),
      'ingredients_raw': ingredientsRaw,
      'ingredients_raw_tr': ingredientsRawTr,
      'instructions': instructions,
      'instructions_tr': instructionsTr,
      'cooking_methods': cookingMethods,
      'implements': implementsList,
      'number_of_steps': numberOfSteps,
      'servings': servings,
      'servings_tr': servingsTr,
      'nutrition_raw': nutritionRaw,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'cholesterol': cholesterol,
      'fiber': fiber,
      'protein': protein,
      'saturated_fat': saturatedFat,
      'sodium': sodium,
      'sugar': sugar,
      'fat': fat,
      'unsaturated_fat': unsaturatedFat,
      'url': url,
    };
  }

  factory Food.empty() => Food(
        recipeId: 0,
        name: '',
        nameTr: '',
      );

  @override
  String toString() {
    return 'Food(recipeId: $recipeId, name: $name, rating: $ratingValue, '
        'prep: $prepTimeMinutes, cook: $cookTimeMinutes, categories: $categories)';
  }
}

// ------------------------
//  HELPER PARSE METODLARI
// ------------------------

double? _parseNumeric(dynamic value) {
  if (value == null || value == '' || value == 'character(0)') return null;

  if (value is num) return value.toDouble();

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    // "4,5", "93 kcal", "24 g" gibi degerleri normalize et
    final cleaned = trimmed.replaceAll(RegExp(r'[^0-9,\.\-]'), '');
    if (cleaned.isEmpty) return null;

    return double.tryParse(cleaned.replaceAll(',', '.'));
  }

  return null;
}

int? _parseInt(dynamic value) {
  final d = _parseNumeric(value);
  return d?.round();
}

/// CSV'den gelen veya Supabase'ten gelen string/list array'lerini normalize eder.
List<String> _parseStringList(dynamic value) {
  if (value == null || value == '' || value == 'character(0)') {
    return <String>[];
  }

  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return <String>[];

    // JSON / Python repr list: ['a', 'b'] / ["a", "b"]
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final normalized = trimmed.replaceAll("'", '"');
        final decoded = jsonDecode(normalized);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // Devam edip fallback'e dus
      }

      // Fallback: koseli parantezleri atip virglden bol
      final inner = trimmed.substring(1, trimmed.length - 1);
      return inner.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    // Tek string degerse
    return <String>[trimmed];
  }

  return <String>[];
}

/// Ingredients icin Map listesi parse eder.
/// CSV'de: "[{'ingredient': 'pineapple', 'quantity': '1', ...}, ...]"
List<Map<String, dynamic>> _parseMapList(dynamic value) {
  if (value == null || value == '' || value == 'character(0)') {
    return <Map<String, dynamic>>[];
  }

  if (value is List) {
    return value.map<Map<String, dynamic>>((e) {
      if (e is Map) {
        return Map<String, dynamic>.from(e);
      }
      return <String, dynamic>{'value': e.toString()};
    }).toList();
  }

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return <Map<String, dynamic>>[];

    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final normalized = trimmed.replaceAll("'", '"');
        final decoded = jsonDecode(normalized);
        if (decoded is List) {
          return decoded.map<Map<String, dynamic>>((e) {
            if (e is Map) {
              return Map<String, dynamic>.from(e);
            }
            return <String, dynamic>{'value': e.toString()};
          }).toList();
        }
      } catch (_) {
        // Fallback'e dus
      }
    }

    // Fallback: tek bir string ise raw value olarak tut
    return <Map<String, dynamic>>[
      <String, dynamic>{'value': trimmed},
    ];
  }

  return <Map<String, dynamic>>[];
}

/// Merge misc + ingredient names, remove trivial phrases, normalize spacing.
String _combineIngredientName(String name, String misc) {
  final List<String> parts = [];
  if (misc.isNotEmpty) parts.add(misc);
  if (name.isNotEmpty) parts.add(name);
  if (parts.isEmpty) return '';

  final combined = parts.join(' ');
  return combined
      .replaceAll(RegExp(r'\b(to taste|taste)\b', caseSensitive: false), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// EN + TR ingredient listelerini birlestirip Ingredient listesine cevirir.
List<Ingredient> _buildIngredientList(
  dynamic enValue,
  dynamic trValue,
) {
  final enList = _parseMapList(enValue);
  final trList = _parseMapList(trValue);

  final result = <Ingredient>[];
  final maxLen = enList.length > trList.length ? enList.length : trList.length;

  for (var i = 0; i < maxLen; i++) {
    final en = i < enList.length ? enList[i] : const <String, dynamic>{};
    final tr = i < trList.length ? trList[i] : const <String, dynamic>{};

    final enNameRaw = (en['ingredient'] ?? en['Ingredient'] ?? en['value'] ?? '').toString().trim();
    final trNameRaw = (tr['ingredient'] ?? tr['Ingredient_tr'] ?? tr['Ingredient'] ?? tr['value'] ?? '').toString().trim();
    final enMisc = (en['misc'] ?? '').toString().trim();
    final trMisc = (tr['misc'] ?? '').toString().trim();

    final enName = _combineIngredientName(enNameRaw, enMisc);
    final trName = _combineIngredientName(trNameRaw, trMisc);

    if (enName.isEmpty && trName.isEmpty) continue;

    // Quantity / Unit / Misc su an Ingredient'ta yoksa,
    // sadece ad / ad_tr gonderiyoruz. Sen Ingredient'i genisletirsen burayi guncelleyebilirsin.
    result.add(
      Ingredient(
        name: enName,
        nameTr: trName,
      ),
    );
  }

  return result;
}

/// Nutrition string veya jsonb -> Map<>
Map<String, String> _parseNutritionText(dynamic value) {
  if (value == null || value == '' || value == 'character(0)') {
    return <String, String>{};
  }

  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(
        key.toString(),
        val?.toString() ?? '',
      ),
    );
  }

  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return <String, String>{};

    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final normalized = trimmed.replaceAll("'", '"');
        final decoded = jsonDecode(normalized);
        if (decoded is Map) {
          return decoded.map(
            (key, val) => MapEntry(
              key.toString(),
              val?.toString() ?? '',
            ),
          );
        }
      } catch (_) {
        // Fallback
      }
    }
  }

  return <String, String>{};
}

/// Enum icin helper
CategoriesEnum? _parseCategoryEnum(List<String> categories) {
  if (categories.isEmpty) {
    return CategoriesEnum.fromLabel('None');
  }

  // Ilk kategoriyi kullan
  return CategoriesEnum.fromLabel(categories.first);
}
