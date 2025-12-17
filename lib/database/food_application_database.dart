import 'package:flutter/material.dart';
import '../classes/favorites_class.dart';
import '../classes/ingredient_class.dart';
import 'dart:convert';

class FoodApplicationDataBase extends ChangeNotifier {
  FoodApplicationDataBase({
    required this.ver,
    required this.languageCode,
    required this.initialIngredients,
    required this.favorites,
  });

  int ver; // Version of the database
  int languageCode; // Selected language code (e.g., 0 = English, 1 = Turkish)
  List<IngredientClass> initialIngredients; // List of initial ingredients
  List<Favorite> favorites; // List of favorite recipes

  /// Converts the list of ingredient values to a list of strings
  List<String> convertIngredientValuesToStringList() => initialIngredients.map((ingredient) => ingredient.Ingredient_tr).toList();

  /// Adds an ingredient and notifies listeners
  void addIngredient(IngredientClass ingredient) {
    initialIngredients.add(ingredient);
    notifyListeners(); // UI'yi güncelle
  }

  /// Removes an ingredient and notifies listeners
  void removeIngredient(IngredientClass ingredient) {
    initialIngredients.remove(ingredient);
    notifyListeners(); // UI'yi güncelle
  }

  /// Converts the object into a Map representation
  Map<String, dynamic> toMap() {
    return {
      'Ver': ver,
      'languageCode': languageCode,
      'InitialIngredients': jsonEncode(initialIngredients.map((e) => e.toMap()).toList()),
      'Favorites': jsonEncode(favorites.map((e) => e.toMap()).toList()),
    };
  }

  /// Creates a `FoodApplicationDataBase` object from a Map
  factory FoodApplicationDataBase.fromMap(Map<dynamic, dynamic> map) {
    return FoodApplicationDataBase(
      ver: map['Ver'] ?? 0,
      languageCode: map['languageCode'] ?? 0,
      initialIngredients: (jsonDecode(map['InitialIngredients']) as List<dynamic>).map((e) => IngredientClass.fromMap(e)).toList(),
      favorites: (map.containsKey('Favorites') && map['Favorites'] != null) ? (jsonDecode(map['Favorites']) as List<dynamic>).map((e) => Favorite.fromMap(e)).toList() : [],
    );
  }

  @override
  String toString() => 'FoodApplicationDataBase(Ver: $ver, languageCode: $languageCode, InitialIngredients: $initialIngredients, Favorites: $favorites)';
}
