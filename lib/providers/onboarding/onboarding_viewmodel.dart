import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/global/app_globals.dart';
import 'package:yemek_tarifi_app/models/onboarding/onboarding_step.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(this._service)
      : steps = List.unmodifiable(
          [
            OnboardingStep(
              titleKey: 'onboardingTitle1',
              descriptionKey: 'onboardingBody1',
              icon: Icons.auto_awesome,
              gradientColors: [AppTheme.seedColor, AppTheme.accentColor],
            ),
            OnboardingStep(
              titleKey: 'onboardingTitle2',
              descriptionKey: 'onboardingBody2',
              icon: Icons.kitchen_rounded,
              gradientColors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
            ),
            OnboardingStep(
              titleKey: 'onboardingTitle3',
              descriptionKey: 'onboardingBody3',
              icon: Icons.favorite_rounded,
              gradientColors: [Color(0xFFF97316), Color(0xFFFB7185)],
            ),
          ],
        );

  final OnboardingService _service;
  final PageController pageController = PageController();
  final List<OnboardingStep> steps;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  bool get isLastPage => _currentIndex == steps.length - 1;

  void updateIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> nextPage() async {
    if (isLastPage) return;
    await pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> complete() async {
    await _service.markSeen();
    isFirstLaunch = false;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
