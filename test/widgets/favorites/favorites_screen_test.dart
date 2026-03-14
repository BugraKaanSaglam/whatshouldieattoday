import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/providers/favorites/favorites_viewmodel.dart';
import 'package:yemek_tarifi_app/screens/favorites/favorites_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('FavoritesScreen shows empty state when there are no favorites', (
    tester,
  ) async {
    final viewModel = FavoritesViewModel(
      reconcileFavorites: ({required backfillMissingCache}) async {},
      favoritesReader: () => const [],
      cacheWriter: (food, {category}) async {},
      onlineChecker: () => true,
    );

    await tester.pumpWidget(
      buildTestApp(FavoritesScreen(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Favorite Recipes'), findsOneWidget);
    expect(
      find.text('You do not have any favorite recipes yet.'),
      findsOneWidget,
    );
  });
}
