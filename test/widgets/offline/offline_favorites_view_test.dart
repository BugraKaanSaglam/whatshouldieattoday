import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/widgets/offline/offline_favorites_view.dart';

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
      initialIngredients: const [],
      favorites: const [],
    );
  });

  testWidgets('OfflineFavoritesView shows empty state text without favorites', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const OfflineFavoritesView()));
    await tester.pumpAndSettle();

    expect(find.text('You are offline'), findsOneWidget);
    expect(find.text('Available offline'), findsOneWidget);
    expect(find.text('No offline favorites'), findsOneWidget);
  });
}
