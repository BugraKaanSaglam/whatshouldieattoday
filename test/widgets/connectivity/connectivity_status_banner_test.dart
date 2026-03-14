import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/widgets/connectivity_status_banner.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('shows offline banner content when offline', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const ConnectivityStatusBanner(isOnline: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('No connection'), findsOneWidget);
    expect(
      find.text('Some online features are temporarily unavailable.'),
      findsOneWidget,
    );
  });

  testWidgets('renders banner widget tree when online', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const ConnectivityStatusBanner(isOnline: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ConnectivityStatusBanner), findsOneWidget);
  });
}
