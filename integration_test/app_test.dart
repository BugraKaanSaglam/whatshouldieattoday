import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/providers/home/main_viewmodel.dart';
import 'package:yemek_tarifi_app/screens/home/main_screen.dart';

import '../test/test_helpers/test_asset_loader.dart';

class _OnlineConnectionMonitor extends ConnectionMonitor {
  @override
  bool get isOnline => true;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    isFirstLaunch = false;
    globalDataBase = FoodApplicationDatabase(
      ver: 0,
      languageCode: 0,
      initialIngredients: const [],
      favorites: <Favorite>[],
    );
  });

  testWidgets('main dashboard smoke test', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        MainScreen(
          viewModel: MainViewModel(totalRecipeCountLoader: () async => 39699),
          connectionMonitor: _OnlineConnectionMonitor(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('What Should I Eat Today?'), findsOneWidget);
    expect(find.text('Start Cooking!'), findsOneWidget);
    expect(find.text('My Favorite Recipes'), findsOneWidget);
  });
}
