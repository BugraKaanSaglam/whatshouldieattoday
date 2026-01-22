import 'package:flutter/material.dart';
import 'package:yemek_tarifi_app/features/favorites/models/favorite.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'dart:convert';

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
  List<String> convertIngredientValuesToStringList() => initialIngredients.map((ingredient) => ingredient.nameTr).toList();

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
      'InitialIngredients': jsonEncode(initialIngredients.map((e) => e.toMap()).toList()),
      'Favorites': jsonEncode(favorites.map((e) => e.toMap()).toList()),
    };
  }

  /// Creates a `FoodApplicationDatabase` object from a Map
  factory FoodApplicationDatabase.fromMap(Map<dynamic, dynamic> map) {
    return FoodApplicationDatabase(
      ver: map['Ver'] ?? 0,
      languageCode: map['LanguageCode'] ?? map['languageCode'] ?? 0,
      initialIngredients: (jsonDecode(map['InitialIngredients']) as List<dynamic>).map((e) => Ingredient.fromMap(e)).toList(),
      favorites: (map.containsKey('Favorites') && map['Favorites'] != null) ? (jsonDecode(map['Favorites']) as List<dynamic>).map((e) => Favorite.fromMap(e)).toList() : [],
    );
  }

  @override
  String toString() => 'FoodApplicationDatabase(Ver: $ver, languageCode: $languageCode, InitialIngredients: $initialIngredients, Favorites: $favorites)';
}
