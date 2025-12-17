// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:yemek_tarifi_app/enums/categories_enum.dart';
import 'ingredient_class.dart';

class Food {
  /// PRIMARY KEY (Supabase: id)
  final int recipeId;

  final String name;
  final String name_tr;

  // Rating
  final double? ratingValue;
  final int? ratingCount;

  // Time (dakika cinsinden)
  final int? prepTimeMinutes; // CSV: Preparation Time
  final int? cookTimeMinutes; // CSV: Cooking Time

  int? get totalTimeMinutes {
    if (prepTimeMinutes == null && cookTimeMinutes == null) return null;
    return (prepTimeMinutes ?? 0) + (cookTimeMinutes ?? 0);
  }

  // Kategoriler / mutfak türü
  final List<String> categories; // CSV: Category (['Dinner', 'Side Dish'] vs)
  final List<String> cuisines; // CSV: Cuisine  (['American', 'Asian'] vs)

  // Malzemeler (structured + raw)
  final List<IngredientClass> ingredients; // CSV: Ingredients (EN, structured)
  final List<IngredientClass> ingredients_tr; // CSV: Ingredients_tr (TR, structured)

  final List<String> ingredientsRaw; // CSV: Ingredients_Raw
  final List<String> ingredientsRaw_tr; // CSV: Ingredients_Raw_tr

  // Adımlar
  final List<String> instructions; // CSV: Instructions
  final List<String> instructions_tr; // CSV: Instructions_tr

  // Pişirme yöntemi / kullanılan ekipmanlar
  final List<String> cookingMethods; // CSV: Cooking Methods
  final List<String> implementsList; // CSV: Implements

  final int? numberOfSteps; // CSV: Number of steps

  // Porsiyon
  final String? servings; // CSV: Servings
  final String? servings_tr; // CSV: Servings_tr

  // Besin değerleri (numeric)
  final double? calories;
  final double? carbohydrates;
  final double? cholesterol;
  final double? fiber;
  final double? protein;
  final double? saturatedFat;
  final double? sodium;
  final double? sugar;
  final double? fat;
  final double? unsaturatedFat;

  /// Orijinal Nutrition text JSON'u (Supabase'te `nutrition_raw` kolonuna basılabilir)
  final Map<String, String> nutritionRaw;

  // Kaynak link
  final String? url;

  /// Convenience: ilk kategoriye göre enum (uygun değilse CategoriesEnum.None vs)
  final CategoriesEnum recipeCategory;

  Food({
    required this.recipeId,
    required this.name,
    required this.name_tr,
    this.ratingValue,
    this.ratingCount,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.categories = const [],
    this.cuisines = const [],
    this.ingredients = const [],
    this.ingredients_tr = const [],
    this.ingredientsRaw = const [],
    this.ingredientsRaw_tr = const [],
    this.instructions = const [],
    this.instructions_tr = const [],
    this.cookingMethods = const [],
    this.implementsList = const [],
    this.numberOfSteps,
    this.servings,
    this.servings_tr,
    this.calories,
    this.carbohydrates,
    this.cholesterol,
    this.fiber,
    this.protein,
    this.saturatedFat,
    this.sodium,
    this.sugar,
    this.fat,
    this.unsaturatedFat,
    this.nutritionRaw = const {},
    this.url,
    required this.recipeCategory,
  });

  // ------------------------
  //  HELPER PARSE METODLARI
  // ------------------------

  static double? _parseNumeric(dynamic value) {
    if (value == null || value == '' || value == 'character(0)') return null;

    if (value is num) return value.toDouble();

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;

      // "4,5", "93 kcal", "24 g" gibi değerleri normalize et
      final cleaned = trimmed.replaceAll(RegExp(r'[^0-9,.\-]'), '');
      if (cleaned.isEmpty) return null;

      return double.tryParse(cleaned.replaceAll(',', '.'));
    }

    return null;
  }

  static int? _parseInt(dynamic value) {
    final d = _parseNumeric(value);
    return d?.round();
  }

  /// CSV'den gelen veya Supabase'ten gelen string/list array'lerini normalize eder.
  static List<String> _parseStringList(dynamic value) {
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
          // Devam edip fallback'e düş
        }

        // Fallback: köşeli parantezleri atıp virgülden böl
        final inner = trimmed.substring(1, trimmed.length - 1);
        return inner.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }

      // Tek string değerse
      return <String>[trimmed];
    }

    return <String>[];
  }

  /// Ingredients için Map listesi parse eder.
  /// CSV'de: "[{'ingredient': 'pineapple', 'quantity': '1', ...}, ...]"
  static List<Map<String, dynamic>> _parseMapList(dynamic value) {
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
          // Fallback'e düş
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
  static String _combineIngredientName(String name, String misc) {
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

  /// EN + TR ingredient listelerini birleştirip IngredientClass listesine çevirir.
  static List<IngredientClass> _buildIngredientList(
    dynamic enValue,
    dynamic trValue,
  ) {
    final enList = _parseMapList(enValue);
    final trList = _parseMapList(trValue);

    final result = <IngredientClass>[];
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

      // Quantity / Unit / Misc şu an IngredientClass'ta yoksa,
      // sadece ad / ad_tr gönderiyoruz. Sen IngredientClass'ı genişletirsen burayı güncelleyebilirsin.
      result.add(
        IngredientClass(
          Ingredient: enName,
          Ingredient_tr: trName,
        ),
      );
    }

    return result;
  }

  /// Nutrition string veya jsonb -> Map<>
  static Map<String, String> _parseNutritionText(dynamic value) {
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

  /// Enum için helper
  static CategoriesEnum? _parseCategoryEnum(List<String> categories) {
    if (categories.isEmpty) {
      return CategoriesEnum.fromLabel('None');
    }

    // İlk kategoriyi kullan
    return CategoriesEnum.fromLabel(categories.first);
  }

  // ------------------------
  //  fromMap (CSV + Supabase)
  // ------------------------

  factory Food.fromMap(Map<String, dynamic> map) {
    // ID (CSV: "Id", eski dataset: "RecipeId", Supabase: "id")
    final dynamic idRaw = map['id'] ?? map['Id'] ?? map['RecipeId'];
    final int recipeId = _parseInt(idRaw) ?? 0;

    final String name = (map['name'] ?? map['Name'] ?? '').toString().trim();
    final String name_tr = (map['name_tr'] ?? map['Name_tr'] ?? name).toString().trim();

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
    final List<IngredientClass> ingredients = _buildIngredientList(
      map['ingredients'] ?? map['Ingredients'],
      map['ingredients_tr'] ?? map['Ingredients_tr'],
    );

    final List<IngredientClass> ingredients_tr = _buildIngredientList(
      map['ingredients_tr'] ?? map['Ingredients_tr'],
      map['ingredients_tr'] ?? map['Ingredients_tr'],
    );

    // Ingredients raw
    final List<String> ingredientsRaw = _parseStringList(map['ingredients_raw'] ?? map['Ingredients_Raw']);
    final List<String> ingredientsRaw_tr = _parseStringList(map['ingredients_raw_tr'] ?? map['Ingredients_Raw_tr']);

    // Instructions
    final List<String> instructions = _parseStringList(map['instructions'] ?? map['Instructions']);
    final List<String> instructions_tr = _parseStringList(map['instructions_tr'] ?? map['Instructions_tr']);

    // Cooking methods / Implements
    final List<String> cookingMethods = _parseStringList(map['cooking_methods'] ?? map['Cooking Methods']);
    final List<String> implementsList = _parseStringList(map['implements'] ?? map['Implements']);

    // Steps
    final int? numberOfSteps = _parseInt(map['number_of_steps'] ?? map['Number of steps']);

    // Servings
    final String? servings = (map['servings'] ?? map['Servings'])?.toString();
    final String? servings_tr = (map['servings_tr'] ?? map['Servings_tr'])?.toString();

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
      name_tr: name_tr,
      ratingValue: ratingValue,
      ratingCount: ratingCount,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      categories: categories,
      cuisines: cuisines,
      ingredients: ingredients,
      ingredients_tr: ingredients_tr,
      ingredientsRaw: ingredientsRaw,
      ingredientsRaw_tr: ingredientsRaw_tr,
      instructions: instructions,
      instructions_tr: instructions_tr,
      cookingMethods: cookingMethods,
      implementsList: implementsList,
      numberOfSteps: numberOfSteps,
      servings: servings,
      servings_tr: servings_tr,
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
      'name_tr': name_tr,
      'rating_value': ratingValue,
      'rating_count': ratingCount,
      'prep_time': prepTimeMinutes,
      'cook_time': cookTimeMinutes,
      'category': categories,
      'cuisine': cuisines,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'ingredients_tr': ingredients_tr.map((e) => e.toMap()).toList(),
      'ingredients_raw': ingredientsRaw,
      'ingredients_raw_tr': ingredientsRaw_tr,
      'instructions': instructions,
      'instructions_tr': instructions_tr,
      'cooking_methods': cookingMethods,
      'implements': implementsList,
      'number_of_steps': numberOfSteps,
      'servings': servings,
      'servings_tr': servings_tr,
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

  @override
  String toString() {
    return 'Food(recipeId: $recipeId, name: $name, rating: $ratingValue, '
        'prep: $prepTimeMinutes, cook: $cookTimeMinutes, categories: $categories)';
  }
}
