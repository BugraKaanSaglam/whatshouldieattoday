import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/core/utils/checkstring.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  test('customChangeString removes brackets and quotes', () {
    expect(customChangeString("['hello']"), 'hello');
  });

  testWidgets('formatDuration formats minute values', (tester) async {
    await tester.pumpWidget(buildTestApp(const SizedBox()));

    expect(formatDuration(90), '1 hour 30 minutes');
    expect(formatDuration('45'), '45 minutes');
    expect(formatDuration(null), '');
  });

  testWidgets('formatDuration formats ISO strings and seconds fallback', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const SizedBox()));

    expect(formatDuration('PT1H30M'), '1 hour 30 minutes');
    expect(formatDuration('PT45S'), '45 seconds');
  });
}
