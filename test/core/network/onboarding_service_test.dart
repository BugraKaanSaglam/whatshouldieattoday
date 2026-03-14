import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('hasSeenOnboarding is false by default', () async {
    final service = OnboardingService();

    expect(await service.hasSeenOnboarding(), isFalse);
  });

  test('markSeen persists onboarding state', () async {
    final service = OnboardingService();

    await service.markSeen();

    expect(await service.hasSeenOnboarding(), isTrue);
  });
}
