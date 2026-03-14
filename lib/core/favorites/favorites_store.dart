import 'package:yemek_tarifi_app/database/db_helper.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/core/logging/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';

typedef FavoritePersistCallback = Future<void> Function();
typedef FavoriteFoodFetcher = Future<Food?> Function(int recipeId);

class FavoritesStore {
  FavoritesStore._();

  static List<Favorite> get favorites =>
      List<Favorite>.from(globalDataBase?.favorites ?? const <Favorite>[]);

  static bool isFavorite(int recipeId) {
    return globalDataBase?.favorites.any((item) => item.recipeId == recipeId) ??
        false;
  }

  static List<Food> get cachedFoods {
    return favorites
        .map((item) => item.cachedFood)
        .whereType<Food>()
        .toList(growable: false);
  }

  static Future<void> reconcileLocalState({
    bool backfillMissingCache = false,
    FavoritePersistCallback? persistOverride,
    FavoriteFoodFetcher? fetchFoodOverride,
  }) async {
    final favorites = globalDataBase?.favorites;
    if (favorites == null) return;

    bool changed = false;
    final Map<int, Favorite> normalized = <int, Favorite>{};

    for (final favorite in favorites) {
      if (favorite.recipeId <= 0) {
        changed = true;
        continue;
      }

      final Favorite? existing = normalized[favorite.recipeId];
      if (existing == null) {
        normalized[favorite.recipeId] = favorite;
        continue;
      }

      changed = true;
      normalized[favorite.recipeId] = _mergeFavorites(existing, favorite);
    }

    final List<Favorite> nextFavorites = normalized.values.toList();

    if (backfillMissingCache) {
      for (int i = 0; i < nextFavorites.length; i++) {
        final Favorite current = nextFavorites[i];
        if (current.cachedFood != null) continue;

        final Food? fetched = await (fetchFoodOverride ?? _fetchSingleFood)(
          current.recipeId,
        );
        if (fetched == null) continue;

        nextFavorites[i] = current.copyWith(cachedFood: fetched);
        changed = true;
      }
    }

    if (!changed) return;

    globalDataBase!.favorites = nextFavorites;
    await _persist(persistOverride);
  }

  static Future<void> toggleFavorite({
    required Food food,
    required String category,
    FavoritePersistCallback? persistOverride,
  }) async {
    final favorites = globalDataBase?.favorites;
    if (favorites == null) return;

    final int existingIndex = favorites.indexWhere(
      (item) => item.recipeId == food.recipeId,
    );

    if (existingIndex >= 0) {
      favorites.removeAt(existingIndex);
    } else {
      favorites.add(
        Favorite(recipeId: food.recipeId, category: category, cachedFood: food),
      );
    }

    await _persist(persistOverride);
  }

  static Future<void> cacheFood(
    Food food, {
    String? category,
    FavoritePersistCallback? persistOverride,
  }) async {
    final favorites = globalDataBase?.favorites;
    if (favorites == null) return;

    final int existingIndex = favorites.indexWhere(
      (item) => item.recipeId == food.recipeId,
    );
    if (existingIndex < 0) return;

    final Favorite current = favorites[existingIndex];
    favorites[existingIndex] = current.copyWith(
      category: category ?? current.category,
      cachedFood: food,
    );

    await _persist(persistOverride);
  }

  static Future<void> _persist([
    FavoritePersistCallback? persistOverride,
  ]) async {
    if (persistOverride != null) {
      await persistOverride();
      return;
    }
    final db = globalDataBase;
    if (db == null) return;
    await DBHelper().update(db);
  }

  static Favorite _mergeFavorites(Favorite left, Favorite right) {
    return Favorite(
      recipeId: left.recipeId,
      category: left.category.isNotEmpty ? left.category : right.category,
      cachedFood: left.cachedFood ?? right.cachedFood,
    );
  }

  static Future<Food?> _fetchSingleFood(int recipeId) async {
    final SupabaseClient supabase = Supabase.instance.client;
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from(recipesTableName)
          .select()
          .eq('RecipeId', recipeId)
          .limit(1);
      if (data.isEmpty) return null;
      return Food.fromMap(data.first);
    } catch (_) {
      try {
        final List<Map<String, dynamic>> data = await supabase
            .from(recipesTableName)
            .select()
            .eq('Id', recipeId)
            .limit(1);
        if (data.isEmpty) return null;
        return Food.fromMap(data.first);
      } catch (error) {
        AppLogger.w('Favorite cache backfill failed', error);
        return null;
      }
    }
  }
}
