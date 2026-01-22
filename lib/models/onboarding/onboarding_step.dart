import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_step.freezed.dart';

@freezed
class OnboardingStep with _$OnboardingStep {
  const factory OnboardingStep({
    required String titleKey,
    required String descriptionKey,
    required IconData icon,
    required List<Color> gradientColors,
  }) = _OnboardingStep;
}
