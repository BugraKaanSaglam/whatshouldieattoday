import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../classes/favorites_class.dart';
import '../classes/food_class.dart';
import '../global/global_variables.dart';

class FavoritesViewModel extends ChangeNotifier {
  List<Favorite> _favorites = [];
  List<Food?> _loadedFoods = [];
  bool _isLoading = false;

  List<Favorite> get favorites => List.unmodifiable(_favorites);
  List<Food?> get loadedFoods => List.unmodifiable(_loadedFoods);
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _favorites = List.from(globalDataBase?.favorites ?? []);
    _loadedFoods = List<Food?>.filled(_favorites.length, null);
    _isLoading = true;
    notifyListeners();

    final futures = _favorites
        .map((favorite) => _fetchSingleFood(favorite.recipeId).catchError((_) => null))
        .toList();
    _loadedFoods = await Future.wait(futures);

    _isLoading = false;
    notifyListeners();
  }

  Future<Food?> _fetchSingleFood(int recipeId) async {
    final supabase = Supabase.instance.client;
    try {
      final List<Map<String, dynamic>> data = await supabase.from(recipesTableName).select().eq('RecipeId', recipeId).limit(1);
      if (data.isEmpty) return null;
      return Food.fromMap(data.first);
    } catch (_) {
      try {
        final List<Map<String, dynamic>> data = await supabase.from(recipesTableName).select().eq('Id', recipeId).limit(1);
        if (data.isEmpty) return null;
        return Food.fromMap(data.first);
      } catch (e) {
        throw Exception('Error parsing food data: $e');
      }
    }
  }
}
