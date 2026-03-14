import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/core/favorites/favorites_store.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/global/app_images.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/screens/recipes/selected_food_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: const <Ingredient>[],
      favorites: <Favorite>[],
    );
  });

  testWidgets('SelectedFoodScreen renders recipe sections', (tester) async {
    final food = _buildFood();

    await tester.pumpWidget(
      buildTestApp(
        SelectedFoodScreen(
          food,
          recipeId: food.recipeId,
          category: 'Dinner',
          adsEnabled: false,
          imageUrlBuilder: (_) => AppImages.defaultFood,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Pasta'), findsWidgets);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Time Info'), findsOneWidget);
    expect(find.text('Recipe Info'), findsOneWidget);
    expect(find.text('Recipe Steps'), findsWidgets);
    expect(find.textContaining('1. Boil water'), findsOneWidget);
  });

  testWidgets('SelectedFoodScreen toggles favorite add and remove state', (
    tester,
  ) async {
    final food = _buildFood();

    await tester.pumpWidget(
      buildTestApp(
        SelectedFoodScreen(
          food,
          recipeId: food.recipeId,
          category: 'Dinner',
          adsEnabled: false,
          imageUrlBuilder: (_) => AppImages.defaultFood,
          onToggleFavorite: (selectedFood, category) async {
            await FavoritesStore.toggleFavorite(
              food: selectedFood,
              category: category,
              persistOverride: () async {},
            );
          },
          isFavoriteResolver: FavoritesStore.isFavorite,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(globalDataBase!.favorites, isEmpty);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(globalDataBase!.favorites, hasLength(1));
    expect(globalDataBase!.favorites.single.recipeId, food.recipeId);
    expect(globalDataBase!.favorites.single.cachedFood?.name, food.name);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(globalDataBase!.favorites, isEmpty);
  });
}

Food _buildFood() {
  return const Food(
    recipeId: 42,
    name: 'Test Pasta',
    nameTr: 'Test Makarna',
    categories: <String>['Dinner'],
    cuisines: <String>['Italian'],
    ingredients: <Ingredient>[
      Ingredient(name: 'Pasta', nameTr: 'Makarna'),
      Ingredient(name: 'Water', nameTr: 'Su'),
    ],
    ingredientsRaw: <String>['200 g pasta', '1 L water'],
    instructions: <String>['Boil water', 'Cook pasta', 'Serve hot'],
    instructionsTr: <String>['Suyu kaynat', 'Makarnayi pisir', 'Servis et'],
    prepTimeMinutes: 10,
    cookTimeMinutes: 15,
    servings: '2',
    numberOfSteps: 3,
    calories: 500,
    fat: 12,
    saturatedFat: 2,
    cholesterol: 0,
    sodium: 20,
    carbohydrates: 90,
    fiber: 5,
    sugar: 3,
    protein: 14,
    nutritionRaw: <String, String>{'Calories': '500 kcal'},
  );
}
