import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';

class FoodApplicationDatabase extends ChangeNotifier {
  FoodApplicationDatabase({
    required this.ver,
    required this.languageCode,
    required this.initialIngredients,
    required this.favorites,
  });

  int ver; // Version of the database
  int languageCode; // Selected language code (e.g., 0 = English, 1 = Turkish)
  List<Ingredient> initialIngredients; // List of initial ingredients
  List<Favorite> favorites; // List of favorite recipes

  /// Converts the list of ingredient values to a list of strings
  List<String> convertIngredientValuesToStringList() => initialIngredients
      .map(
        (ingredient) => ingredient.nameTr.trim().isNotEmpty
            ? ingredient.nameTr
            : ingredient.name,
      )
      .toList(growable: false);

  /// Adds an ingredient and notifies listeners
  void addIngredient(Ingredient ingredient) {
    initialIngredients.add(ingredient);
    notifyListeners(); // UI'yi güncelle
  }

  /// Removes an ingredient and notifies listeners
  void removeIngredient(Ingredient ingredient) {
    initialIngredients.remove(ingredient);
    notifyListeners(); // UI'yi güncelle
  }

  /// Converts the object into a Map representation
  Map<String, dynamic> toMap() {
    return {
      'Ver': ver,
      'LanguageCode': languageCode,
      'InitialIngredients': jsonEncode(
        initialIngredients.map((e) => e.toMap()).toList(growable: false),
      ),
      'Favorites': jsonEncode(
        favorites.map((e) => e.toMap()).toList(growable: false),
      ),
    };
  }

  /// Creates a `FoodApplicationDatabase` object from a Map
  factory FoodApplicationDatabase.fromMap(Map<dynamic, dynamic> map) {
    List<dynamic> decodeList(Object? raw) {
      if (raw is List) return raw;
      if (raw is! String || raw.trim().isEmpty) return <dynamic>[];
      try {
        final dynamic decoded = jsonDecode(raw);
        return decoded is List ? decoded : <dynamic>[];
      } on FormatException {
        return <dynamic>[];
      }
    }

    final List<Ingredient> ingredients = <Ingredient>[];
    for (final item in decodeList(map['InitialIngredients'])) {
      if (item is! Map) continue;
      try {
        ingredients.add(Ingredient.fromMap(Map<String, dynamic>.from(item)));
      } catch (_) {
        // Ignore one malformed legacy ingredient without losing the database.
      }
    }

    final List<Favorite> decodedFavorites = <Favorite>[];
    for (final item in decodeList(map['Favorites'])) {
      if (item is! Map) continue;
      try {
        decodedFavorites.add(Favorite.fromMap(Map<String, dynamic>.from(item)));
      } catch (_) {
        // Ignore one malformed legacy favorite without losing other favorites.
      }
    }

    return FoodApplicationDatabase(
      ver: int.tryParse('${map['Ver'] ?? 0}') ?? 0,
      languageCode:
          int.tryParse('${map['LanguageCode'] ?? map['languageCode'] ?? 0}') ??
          0,
      initialIngredients: ingredients,
      favorites: decodedFavorites,
    );
  }

  @override
  String toString() =>
      'FoodApplicationDatabase(Ver: $ver, languageCode: $languageCode, '
      'InitialIngredients: $initialIngredients, Favorites: $favorites)';
}
