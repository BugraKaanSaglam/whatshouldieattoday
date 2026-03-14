import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yemek_tarifi_app/screens/feedback/feedback_screen.dart';

import '../../test_helpers/test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('FeedbackScreen renders hero and form fields', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const FeedbackScreen(recipeId: 7, category: 'Dinner')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Feedback'), findsWidgets);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Your Feedback'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
  });
}
