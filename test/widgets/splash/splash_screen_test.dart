import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yemek_tarifi_app/screens/splash/splash_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('SplashScreen shows loading copy', (tester) async {
    await tester.pumpWidget(buildTestApp(const SplashScreen()));
    await tester.pump();

    expect(find.text('Preparing your recipes'), findsOneWidget);
    expect(
      find.text('Loading data and your saved preferences.'),
      findsOneWidget,
    );
  });
}
