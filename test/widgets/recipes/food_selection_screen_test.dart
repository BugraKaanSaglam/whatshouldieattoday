import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/screens/recipes/food_selection_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  setUp(() {
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: const <Ingredient>[],
      favorites: <Favorite>[],
    );
  });

  testWidgets('normal recipe navigation does not open the sheet', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const FoodSelectionScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsNothing);
    expect(find.text('Search For Ingredients'), findsWidgets);

    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Search For Ingredients'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
  });

  testWidgets('openSearch opens once and stays closed after dismissal', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(const FoodSelectionScreen(openSearch: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(DraggableScrollableSheet), findsNothing);
    expect(find.text('Search For Ingredients'), findsWidgets);
  });
}
