import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../classes/food_class.dart';
import '../classes/ingredient_class.dart';
import '../global/global_variables.dart';

/// Centralized Supabase-backed data access.
class BackendService {
  BackendService._();

  static final SupabaseClient _client = Supabase.instance.client;
  static bool debugEnabled = false;

  static void _log(String message, {Object? data}) {
    if (!debugEnabled) return;
    debugPrint('[Backend] $message${data != null ? ' | $data' : ''}');
  }

  /// Ingredient search with TR/EN column awareness.
  static Future<List<IngredientClass>> searchIngredients({
    required String query,
    String tableName = 'Ingredients',
    required bool isTurkish,
  }) async {
    if (query.isEmpty) return <IngredientClass>[];
    final String searchName = isTurkish ? 'Ingredients_tr' : 'Ingredients';

    _log('searchIngredients', data: {'query': query, 'searchName': searchName});

    final List<Map<String, dynamic>> response = await _client.from(tableName).select().ilike(searchName, '%$query%').limit(50);

    _log('searchIngredients response count', data: response.length);

    return response
        .map((item) {
          final String en = item['Ingredients']?.toString() ?? item['Ingredient']?.toString() ?? '';
          final String tr = item['Ingredients_tr']?.toString() ?? item['Ingredient_tr']?.toString() ?? '';
          return IngredientClass(Ingredient: en, Ingredient_tr: tr);
        })
        .where((ing) => ing.Ingredient.isNotEmpty || ing.Ingredient_tr.isNotEmpty)
        .toList();
  }

  /// Fetch recipes via RPC; falls back to table query if RPC unavailable.
  static Future<List<Food>> fetchRecipes({
    required List<String> ingredients,
    required int offset,
    required int limit,
  }) async {
    if (ingredients.isEmpty) throw Exception('Malzeme listesi boş olamaz.');
    final int rangeEnd = offset + limit - 1;

    List<dynamic> rawResults = <dynamic>[];
    bool rpcFailed = false;

    try {
      _log('fetchRecipes RPC start', data: {'offset': offset, 'limit': limit, 'ingredients': ingredients});
      final dynamic response = await _client.rpc(recipeSearchFunctionName, params: {'ingredients': ingredients}).range(offset, rangeEnd);
      if (response is List) rawResults = response;
      _log('fetchRecipes RPC ok', data: rawResults.length);
    } on PostgrestException catch (e) {
      rpcFailed = true;
      // Statement timeout: surface to user instead of returning unrelated rows.
      if (e.code == '57014') {
        throw Exception('Tarif araması zaman aşımına uğradı. Lütfen daha az malzeme seçerek tekrar deneyin.');
      }
      _log('fetchRecipes RPC failed, fallback to table', data: {'code': e.code, 'message': e.message});
    } catch (e) {
      rpcFailed = true;
      _log('fetchRecipes RPC failed, fallback to table', data: e.toString());
    }

    if (rpcFailed) {
      rawResults = await _fetchRecipesFallback(ingredients: ingredients, offset: offset, limit: limit);
    }

    final List<Food> validRecipes = <Food>[];
    for (final item in rawResults) {
      if (item is! Map<String, dynamic>) continue;
      try {
        validRecipes.add(Food.fromMap(item));
      } catch (_) {
        // Skip invalid rows silently.
      }
    }
    return validRecipes;
  }

  static Future<List<dynamic>> _fetchRecipesFallback({
    required List<String> ingredients,
    required int offset,
    required int limit,
  }) async {
    final int rangeEnd = offset + limit - 1;
    const List<String> fallbackColumns = ['ingredients_tokens', 'ingredients', 'ingredients_raw'];

    for (final column in fallbackColumns) {
      try {
        _log('fetchRecipes fallback try', data: {'column': column, 'ingredients': ingredients});
        final dynamic response = await _client.from(recipesTableName).select().contains(column, ingredients).range(offset, rangeEnd);
        if (response is List) {
          _log('fetchRecipes fallback ok', data: {'column': column, 'count': response.length});
          return response;
        }
      } catch (e) {
        _log('fetchRecipes fallback failed', data: {'column': column, 'error': e.toString()});
      }
    }

    throw Exception('Tarif araması geçici olarak kullanılamıyor. Lütfen daha sonra tekrar deneyin.');
  }

  /// Fetch only total count via RPC (requires SQL function `get_recipes_count`).
  static Future<int?> fetchRecipesCount({required List<String> ingredients}) async {
    try {
      _log('fetchRecipesCount RPC start', data: {'ingredients': ingredients});
      final dynamic response = await _client.rpc('get_recipes_count', params: {'ingredients': ingredients});
      if (response is int) {
        _log('fetchRecipesCount RPC ok', data: response);
        return response;
      }
      if (response is double) {
        final int val = response.round();
        _log('fetchRecipesCount RPC ok (double)', data: val);
        return val;
      }
    } catch (e) {
      _log('fetchRecipesCount failed', data: e.toString());
    }
    return null;
  }

  /// Fetch total recipes count from Supabase table.
  static Future<int?> fetchTotalRecipesCount() async {
    try {
      final int count = await _client.from(recipesTableName).count();
      return count;
    } catch (e) {
      _log('fetchTotalRecipesCount failed', data: e.toString());
    }
    return null;
  }

  /// Generic table row count.
  static Future<int?> fetchTableCount({required String tableName}) async {
    try {
      return await _client.from(tableName).count();
    } catch (e) {
      _log('fetchTableCount failed', data: {'table': tableName, 'error': e.toString()});
    }
    return null;
  }

  /// Submit feedback to Supabase.
  static Future<void> submitFeedback({required int recipeId, required String? email, required String message}) async {
    _log('submitFeedback', data: {'recipeId': recipeId});
    await _client.from('Feedback').insert({
      'RecipeId': recipeId,
      'Email': (email != null && email.isNotEmpty) ? email : null,
      'Message': message,
      'Created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Public URL for recipe image in storage (RecipeImages bucket, {id}.jpg).
  static String recipeImagePublicUrl(int recipeId) {
    return _client.storage.from('RecipeImages').getPublicUrl('$recipeId.jpg');
  }
}
