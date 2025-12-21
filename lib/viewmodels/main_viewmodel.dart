import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../global/global_variables.dart';

class MainViewModel extends ChangeNotifier {
  bool _isPopupShown = false;
  int? _totalRecipeCount;
  bool _isFetchingRecipes = false;

  int? get totalRecipeCount => _totalRecipeCount;
  bool get isBlinking => isFirstLaunch && !_isPopupShown;

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

  Future<void> scheduleInitialPopup(Future<void> Function() showDialogCallback) async {
    if (!isFirstLaunch || _isPopupShown) return;
    _isPopupShown = true;
    notifyListeners();

    await Future.delayed(Durations.extralong4);
    try {
      await showDialogCallback();
    } finally {
      isFirstLaunch = false;
      notifyListeners();
    }
  }
}
