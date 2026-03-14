import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/models/recipe/ingredient.dart';
import 'package:yemek_tarifi_app/screens/settings/settings_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 1,
      initialIngredients: const <Ingredient>[],
      favorites: <Favorite>[],
    );
  });

  testWidgets('SettingsScreen exposes share app actions', (tester) async {
    int shareCount = 0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 2200);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestApp(
        SettingsScreen(
          shareHandler: (subject, text) async {
            shareCount++;
          },
          urlLauncher: (uri) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final shareButton = find.text('Share app');
    final appStoreButton = find.text('Open App Store');
    final playStoreButton = find.text('Open Google Play');

    expect(find.text('Share the app'), findsOneWidget);
    expect(appStoreButton, findsOneWidget);
    expect(playStoreButton, findsOneWidget);

    await tester.tap(shareButton);
    await tester.pumpAndSettle();

    expect(shareCount, 1);
  });
}
