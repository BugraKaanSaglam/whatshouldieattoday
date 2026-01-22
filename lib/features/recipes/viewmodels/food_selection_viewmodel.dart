import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import 'package:yemek_tarifi_app/core/services/backend_service.dart';
import 'package:yemek_tarifi_app/features/recipes/models/food.dart';
import 'package:yemek_tarifi_app/features/recipes/models/ingredient.dart';
import 'package:yemek_tarifi_app/features/recipes/models/food_selection_dto.dart';

class FoodSelectionViewModel extends ChangeNotifier {
  final FoodSelectionDTO _formDTO = FoodSelectionDTO();
  final List<Food> _filteredFoodList = [];
  final int _pageSize = 20;
  final bool _filterDebugEnabled = false;

  bool _isSearchedOnce = false;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int? _totalMatches;

  List<Ingredient> get selectedIngredients => List.unmodifiable(_formDTO.ingredients);
  List<Food> get filteredFoodList => List.unmodifiable(_filteredFoodList);
  bool get isSearchedOnce => _isSearchedOnce;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  int? get totalMatches => _totalMatches;

  void init({required List<Ingredient> initialIngredients}) {
    _formDTO.ingredients = List.from(initialIngredients);
  }

  void updateSelectedIngredients(List<Ingredient> items) {
    _formDTO.ingredients = List.from(items);
    notifyListeners();
  }

  Future<String?> startFiltering() async {
    _isSearchedOnce = true;
    _currentPage = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _totalMatches = null;
    notifyListeners();

    try {
      final List<String> selectedIngredients = _formDTO.ingredients.map((e) => e.name).toList();
      if (selectedIngredients.isEmpty) throw Exception('noIngSelected'.tr());

      try {
        final int? count = await BackendService.fetchRecipesCount(ingredients: selectedIngredients);
        _totalMatches = count;
      } catch (e) {
        _logFilter('count rpc failed', e.toString());
      }

      final filteredFoods = await _fetchFilteredFoods(offset: 0, limit: _pageSize);
      _filteredFoodList
        ..clear()
        ..addAll(filteredFoods);
      _currentPage = 1;
      _hasMore = filteredFoods.length == _pageSize;
      _totalMatches ??= filteredFoods.length;
      notifyListeners();
      return null;
    } catch (e) {
      _resetResults();
      return _formatError(e);
    }
  }

  Future<void> refreshResults() async {
    if (!isSearchedOnce) return;
    try {
      final List<String> selectedIngredients = _formDTO.ingredients.map((e) => e.name).toList();
      try {
        final int? count = await BackendService.fetchRecipesCount(ingredients: selectedIngredients);
        _totalMatches = count;
      } catch (e) {
        _logFilter('count rpc failed refresh', e.toString());
      }
      final refreshed = await _fetchFilteredFoods(offset: 0, limit: _pageSize);
      _filteredFoodList
        ..clear()
        ..addAll(refreshed);
      _currentPage = 1;
      _hasMore = refreshed.length == _pageSize;
      _totalMatches ??= refreshed.length;
      notifyListeners();
    } catch (_) {
      // keep current results if refresh fails
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || !_isSearchedOnce) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final nextOffset = _currentPage * _pageSize;
      final newFoods = await _fetchFilteredFoods(offset: nextOffset, limit: _pageSize);
      _filteredFoodList.addAll(newFoods);
      _currentPage++;
      _hasMore = newFoods.length == _pageSize;
    } catch (e) {
      _logFilter('loadMore failed', e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<List<Food>> _fetchFilteredFoods({required int offset, required int limit}) async {
    final List<String> selectedIngredients = _formDTO.ingredients.map((e) => e.name).toList();
    if (selectedIngredients.isEmpty) throw Exception('noIngSelected'.tr());
    final List<Food> recipes = await BackendService.fetchRecipes(ingredients: selectedIngredients, offset: offset, limit: limit);
    List<Food> filtered = List<Food>.from(recipes);

    filtered.sort((a, b) {
      final String catA = a.categories.isNotEmpty ? a.categories.first.toLowerCase() : '';
      final String catB = b.categories.isNotEmpty ? b.categories.first.toLowerCase() : '';
      final int catCompare = catA.compareTo(catB);
      if (catCompare != 0) return catCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    if (_filterDebugEnabled) {
      _logFilter('backend returned', {'count': recipes.length, 'offset': offset, 'limit': limit});
      _logFilter('after client filter', {'count': filtered.length});
    }

    return filtered;
  }

  void _resetResults() {
    _filteredFoodList.clear();
    _currentPage = 0;
    _hasMore = false;
    _isLoadingMore = false;
    _totalMatches = 0;
    notifyListeners();
  }

  String _formatError(Object e) {
    if (e is Exception) return e.toString().replaceFirst('Exception: ', '');
    return 'unknownError'.tr();
  }

  void _logFilter(String message, Object? data) {
    if (!_filterDebugEnabled) return;
    debugPrint('[Filter] $message${data != null ? ' | $data' : ''}');
  }
}
