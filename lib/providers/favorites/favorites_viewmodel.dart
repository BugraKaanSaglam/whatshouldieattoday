import 'package:flutter/foundation.dart';

import 'package:yemek_tarifi_app/core/favorites/favorites_store.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/food.dart';

typedef FavoriteReconcileCallback =
    Future<void> Function({required bool backfillMissingCache});
typedef FavoritesReader = List<Favorite> Function();
typedef FavoriteFoodLoader = Future<Food?> Function(int recipeId);
typedef FavoriteCacheWriter =
    Future<void> Function(Food food, {String? category});
typedef OnlineChecker = bool Function();

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    this.cacheOnly = false,
    FavoriteReconcileCallback? reconcileFavorites,
    FavoritesReader? favoritesReader,
    FavoriteFoodLoader? foodLoader,
    FavoriteCacheWriter? cacheWriter,
    OnlineChecker? onlineChecker,
  }) : _reconcileFavorites =
           reconcileFavorites ?? FavoritesStore.reconcileLocalState,
       _favoritesReader = favoritesReader ?? (() => FavoritesStore.favorites),
       _foodLoader = foodLoader,
       _cacheWriter = cacheWriter ?? FavoritesStore.cacheFood,
       _onlineChecker =
           onlineChecker ?? (() => ConnectionMonitor.shared.isOnline);

  final bool cacheOnly;
  final FavoriteReconcileCallback _reconcileFavorites;
  final FavoritesReader _favoritesReader;
  final FavoriteFoodLoader? _foodLoader;
  final FavoriteCacheWriter _cacheWriter;
  final OnlineChecker _onlineChecker;
  List<Favorite> _favorites = [];
  List<Food?> _loadedFoods = [];
  bool _isLoading = false;
  bool _showingCachedOnly = false;

  List<Favorite> get favorites => List.unmodifiable(_favorites);
  List<Food?> get loadedFoods => List.unmodifiable(_loadedFoods);
  bool get isLoading => _isLoading;
  bool get showingCachedOnly => _showingCachedOnly;

  Future<void> loadFavorites() async {
    final bool isOnline = _onlineChecker();
    await _reconcileFavorites(backfillMissingCache: !cacheOnly && isOnline);
    _favorites = _favoritesReader();
    _loadedFoods = _favorites.map((item) => item.cachedFood).toList();
    _isLoading = true;
    _showingCachedOnly = cacheOnly || !isOnline;
    notifyListeners();

    if (_favorites.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (_showingCachedOnly) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final Map<int, Food> remoteById;
    if (_foodLoader != null) {
      final List<Food?> loaded = await Future.wait(
        _favorites.map((favorite) => _fetchSingleFood(favorite.recipeId)),
      );
      remoteById = <int, Food>{
        for (int i = 0; i < loaded.length; i++)
          if (loaded[i] != null) _favorites[i].recipeId: loaded[i]!,
      };
    } else {
      remoteById = await BackendService.fetchRecipesByIds(
        _favorites.map((favorite) => favorite.recipeId),
      );
    }
    _loadedFoods = List<Food?>.generate(_favorites.length, (index) {
      final Food? remote = remoteById[_favorites[index].recipeId];
      final Food? cached = _favorites[index].cachedFood;
      return remote ?? cached;
    });

    for (int i = 0; i < _favorites.length; i++) {
      final Food? remote = remoteById[_favorites[i].recipeId];
      if (remote != null) {
        await _cacheWriter(remote, category: _favorites[i].category);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Food?> _fetchSingleFood(int recipeId) async {
    if (_foodLoader != null) {
      return _foodLoader(recipeId);
    }
    return BackendService.fetchRecipeById(recipeId);
  }
}
