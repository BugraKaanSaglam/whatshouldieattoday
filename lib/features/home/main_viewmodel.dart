import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/core/services/backend_service.dart';
import 'package:yemek_tarifi_app/core/constants/app_globals.dart';

class MainViewModel extends ChangeNotifier {
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
      final int? count = await BackendService.fetchTotalRecipesCount();
      _totalRecipeCount = count;
    } catch (_) {
      // silently ignore for now
    } finally {
      _isFetchingRecipes = false;
      notifyListeners();
    }
  }
}
