import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';
import 'package:yemek_tarifi_app/providers/favorites/favorites_viewmodel.dart';

void main() {
  test('cacheOnly mode serves cached foods without remote fetch', () async {
    final cached = const Food(recipeId: 1, name: 'Soup', nameTr: 'Corba');
    bool remoteCalled = false;

    final viewModel = FavoritesViewModel(
      cacheOnly: true,
      reconcileFavorites: ({required backfillMissingCache}) async {},
      favoritesReader: () => <Favorite>[
        Favorite(recipeId: 1, category: 'Dinner', cachedFood: cached),
      ],
      foodLoader: (recipeId) async {
        remoteCalled = true;
        return cached;
      },
      cacheWriter: (food, {category}) async {},
      onlineChecker: () => true,
    );

    await viewModel.loadFavorites();

    expect(viewModel.showingCachedOnly, isTrue);
    expect(viewModel.loadedFoods.single?.recipeId, 1);
    expect(remoteCalled, isFalse);
  });

  test(
    'online mode prefers remote foods and falls back to cached copy',
    () async {
      final remote = const Food(
        recipeId: 1,
        name: 'Remote Soup',
        nameTr: 'Corba',
      );
      final cached = const Food(
        recipeId: 2,
        name: 'Local Pasta',
        nameTr: 'Makarna',
      );
      final List<int> cachedWrites = <int>[];
      bool reconcileBackfill = false;

      final viewModel = FavoritesViewModel(
        reconcileFavorites: ({required backfillMissingCache}) async {
          reconcileBackfill = backfillMissingCache;
        },
        favoritesReader: () => <Favorite>[
          const Favorite(recipeId: 1, category: 'Dinner'),
          Favorite(recipeId: 2, category: 'Dinner', cachedFood: cached),
        ],
        foodLoader: (recipeId) async {
          if (recipeId == 1) return remote;
          return null;
        },
        cacheWriter: (food, {category}) async {
          cachedWrites.add(food.recipeId);
        },
        onlineChecker: () => true,
      );

      await viewModel.loadFavorites();

      expect(reconcileBackfill, isTrue);
      expect(viewModel.showingCachedOnly, isFalse);
      expect(viewModel.loadedFoods[0]?.name, 'Remote Soup');
      expect(viewModel.loadedFoods[1]?.name, 'Local Pasta');
      expect(cachedWrites, [1]);
    },
  );
}
