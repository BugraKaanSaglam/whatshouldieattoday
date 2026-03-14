import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/database/food_application_database.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/favorites/favorite.dart';
import 'package:yemek_tarifi_app/providers/home/main_viewmodel.dart';
import 'package:yemek_tarifi_app/screens/home/main_screen.dart';

import '../test/test_helpers/test_asset_loader.dart';

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('MainScreen switches from offline state to online dashboard', (
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

    monitor.setOnline(true);
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('What Should I Eat Today?'), findsOneWidget);
    expect(find.text('Start Cooking!'), findsOneWidget);
    expect(find.text('My Favorite Recipes'), findsOneWidget);
  });
}
