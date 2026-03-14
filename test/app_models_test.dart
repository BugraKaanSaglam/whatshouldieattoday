import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';

void main() {
  test('FoodApplicationDatabase maps LanguageCode consistently', () {
    final db = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: [Ingredient(name: 'salt', nameTr: 'tuz')],
      favorites: [
        Favorite(
          recipeId: 1,
          category: 'Dinner',
          cachedFood: Food(recipeId: 1, name: 'Pasta', nameTr: 'Makarna'),
        ),
      ],
    );

    final map = db.toMap();
    expect(map['LanguageCode'], 1);

    final restored = FoodApplicationDatabase.fromMap({
      'Ver': 0,
      'LanguageCode': 1,
      'InitialIngredients': jsonEncode([
        {'Ingredient': 'salt', 'Ingredient_tr': 'tuz'},
      ]),
      'Favorites': jsonEncode([
        {
          'recipeId': 1,
          'category': 'Dinner',
          'cachedFood': {'id': 1, 'name': 'Pasta', 'name_tr': 'Makarna'},
        },
      ]),
    });

    expect(restored.languageCode, 1);
    expect(restored.initialIngredients.length, 1);
    expect(restored.favorites.length, 1);
    expect(restored.favorites.first.cachedFood?.name, 'Pasta');
  });

  test('Food.fromMap parses basic fields', () {
    final food = Food.fromMap({
      'Id': '42',
      'Name': 'Pasta',
      'Name_tr': 'Makarna',
      'Category': "['Dinner']",
      'Cuisine': "['Italian']",
      'Ingredients': "[{'ingredient':'tomato','misc':'chopped'}]",
      'Ingredients_tr': "[{'ingredient':'domates','misc':'dogranmis'}]",
      'Instructions': "['Step 1']",
      'Instructions_tr': "['Adim 1']",
    });

    expect(food.recipeId, 42);
    expect(food.categories, ['Dinner']);
    expect(food.cuisines, ['Italian']);
    expect(food.ingredients.first.name, 'chopped tomato');
  });
}
