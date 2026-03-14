import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/providers/onboarding/onboarding_viewmodel.dart';

class _FakeOnboardingService extends OnboardingService {
  bool markSeenCalled = false;

  @override
  Future<void> markSeen() async {
    markSeenCalled = true;
  }
}

void main() {
  test('updateIndex updates state and last page flag', () {
    final service = _FakeOnboardingService();
    final viewModel = OnboardingViewModel(service);

    expect(viewModel.currentIndex, 0);
    expect(viewModel.isLastPage, isFalse);

    viewModel.updateIndex(2);

    expect(viewModel.currentIndex, 2);
    expect(viewModel.isLastPage, isTrue);

    viewModel.dispose();
  });

  test('complete marks onboarding seen and clears first launch flag', () async {
    final service = _FakeOnboardingService();
    final viewModel = OnboardingViewModel(service);
    isFirstLaunch = true;

    await viewModel.complete();

    expect(service.markSeenCalled, isTrue);
    expect(isFirstLaunch, isFalse);

    viewModel.dispose();
  });
}
