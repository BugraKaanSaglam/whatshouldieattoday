import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/providers/home/main_viewmodel.dart';
import 'package:yemek_tarifi_app/screens/home/main_screen.dart';
import 'package:yemek_tarifi_app/screens/recipes/food_selection_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

class _FakeConnectionMonitor extends ConnectionMonitor {
  _FakeConnectionMonitor(this._currentOnline);

  bool _currentOnline;

  @override
  bool get isOnline => _currentOnline;

  void setOnline(bool value) {
    _currentOnline = value;
    notifyListeners();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    isFirstLaunch = false;
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: const [],
      favorites: <Favorite>[],
    );
  });

  testWidgets('MainScreen shows offline view when connection is unavailable', (
    tester,
  ) async {
    final monitor = _FakeConnectionMonitor(false);
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => 12);

    await tester.pumpWidget(
      buildTestApp(
        MainScreen(viewModel: viewModel, connectionMonitor: monitor),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('You are offline'), findsOneWidget);
    expect(find.text('Available offline'), findsWidgets);
  });

  testWidgets('MainScreen shows dashboard menu when online', (tester) async {
    final monitor = _FakeConnectionMonitor(true);
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => 12);

    await tester.pumpWidget(
      buildTestApp(
        MainScreen(viewModel: viewModel, connectionMonitor: monitor),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('What Should I Eat Today?'), findsOneWidget);
    expect(find.text('Find recipes'), findsOneWidget);
    expect(find.text('My Favorite Recipes'), findsOneWidget);
    expect(find.text('My Kitchen'), findsOneWidget);
  });

  testWidgets('Find recipes navigates before opening the ingredient sheet', (
    tester,
  ) async {
    final monitor = _FakeConnectionMonitor(true);
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => 12);
    final router = _buildRouter(
      MainScreen(viewModel: viewModel, connectionMonitor: monitor),
    );

    await tester.pumpWidget(
      buildTestApp(const SizedBox.shrink(), router: router),
    );
    await tester.pump(const Duration(milliseconds: 700));
    await tester.tap(find.text('Find recipes'));
    await tester.pumpAndSettle();

    expect(find.byType(FoodSelectionScreen), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['openSearch'],
      isNull,
    );
    expect(find.text('Select Ingredients'), findsOneWidget);
    expect(find.text('Search For Ingredients'), findsWidgets);
  });

  testWidgets('MainScreen keeps selected ingredients in the sheet', (
    tester,
  ) async {
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: [const Ingredient(name: 'Tomato', nameTr: 'Domates')],
      favorites: <Favorite>[],
    );
    final monitor = _FakeConnectionMonitor(true);
    final viewModel = MainViewModel(totalRecipeCountLoader: () async => 12);

    final router = _buildRouter(
      MainScreen(viewModel: viewModel, connectionMonitor: monitor),
    );

    await tester.pumpWidget(
      buildTestApp(const SizedBox.shrink(), router: router),
    );
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Tomato'), findsWidgets);

    await tester.tap(find.text('Find recipes'));
    await tester.pumpAndSettle();
    expect(find.text('Selected ingredients'), findsWidgets);
    expect(find.text('Tomato'), findsWidgets);
  });
}

GoRouter _buildRouter(MainScreen home) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(path: AppRoutes.home, builder: (context, state) => home),
      GoRoute(
        path: AppRoutes.recipes,
        builder: (context, state) {
          final List<Ingredient>? initialIngredients =
              state.extra is List<Ingredient>
              ? List<Ingredient>.from(state.extra as List<Ingredient>)
              : null;
          return FoodSelectionScreen(
            initialIngredients: initialIngredients,
            openSearch: state.uri.queryParameters['openSearch'] == 'true',
          );
        },
      ),
    ],
  );
}
