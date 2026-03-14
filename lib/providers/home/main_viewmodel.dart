import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/core/network/backend_service.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';

typedef TotalRecipeCountLoader = Future<int?> Function();

class MainViewModel extends ChangeNotifier {
  MainViewModel({TotalRecipeCountLoader? totalRecipeCountLoader})
    : _totalRecipeCountLoader =
          totalRecipeCountLoader ?? BackendService.fetchTotalRecipesCount;

  final TotalRecipeCountLoader _totalRecipeCountLoader;
  int? _totalRecipeCount;
  bool _isFetchingRecipes = false;

  int? get totalRecipeCount => _totalRecipeCount;
  bool get isBlinking => isFirstLaunch;

  Future<void> init() async {
    await fetchTotalRecipeCount();
  }

  Future<void> fetchTotalRecipeCount() async {
    if (_isFetchingRecipes) return;
    _isFetchingRecipes = true;
    try {
      final int? count = await _totalRecipeCountLoader();
      _totalRecipeCount = count;
    } catch (_) {
      // silently ignore for now
    } finally {
      _isFetchingRecipes = false;
      notifyListeners();
    }
  }
}
