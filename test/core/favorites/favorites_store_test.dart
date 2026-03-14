import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/favorites/favorites_store.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';

void main() {
  setUp(() {
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: const [],
      favorites: <Favorite>[],
    );
  });

  test('toggleFavorite adds and removes favorites on device state', () async {
    final food = Food(recipeId: 7, name: 'Soup', nameTr: 'Corba');

    await FavoritesStore.toggleFavorite(
      food: food,
      category: 'Dinner',
      persistOverride: () async {},
    );

    expect(globalDataBase!.favorites, hasLength(1));
    expect(globalDataBase!.favorites.first.cachedFood?.recipeId, 7);

    await FavoritesStore.toggleFavorite(
      food: food,
      category: 'Dinner',
      persistOverride: () async {},
    );

    expect(globalDataBase!.favorites, isEmpty);
  });

  test('reconcileLocalState removes invalid and duplicate favorites', () async {
    globalDataBase!.favorites = <Favorite>[
      const Favorite(recipeId: 0, category: 'Invalid'),
      const Favorite(recipeId: 5, category: 'Dinner'),
      Favorite(
        recipeId: 5,
        category: '',
        cachedFood: const Food(recipeId: 5, name: 'Pasta', nameTr: 'Makarna'),
      ),
    ];

    await FavoritesStore.reconcileLocalState(persistOverride: () async {});

    expect(globalDataBase!.favorites, hasLength(1));
    expect(globalDataBase!.favorites.first.recipeId, 5);
    expect(globalDataBase!.favorites.first.category, 'Dinner');
    expect(globalDataBase!.favorites.first.cachedFood?.name, 'Pasta');
  });

  test(
    'reconcileLocalState backfills missing cached food when online data exists',
    () async {
      globalDataBase!.favorites = <Favorite>[
        const Favorite(recipeId: 11, category: 'Dessert'),
      ];

      await FavoritesStore.reconcileLocalState(
        backfillMissingCache: true,
        persistOverride: () async {},
        fetchFoodOverride: (recipeId) async =>
            Food(recipeId: recipeId, name: 'Cake', nameTr: 'Pasta'),
      );

      expect(globalDataBase!.favorites.single.cachedFood?.recipeId, 11);
      expect(globalDataBase!.favorites.single.cachedFood?.name, 'Cake');
    },
  );
}
