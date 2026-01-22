import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/models/onboarding/onboarding_step.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';
import 'package:yemek_tarifi_app/providers/onboarding/onboarding_viewmodel.dart';
import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(OnboardingService()),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, _) => AppScaffold(
          body: Stack(
            children: [
              const _OnboardingBackdrop(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'appName'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await viewModel.complete();
                            onFinished();
                          },
                          child: Text(
                            'onboardingSkip'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      onPageChanged: viewModel.updateIndex,
                      itemCount: viewModel.steps.length,
                      itemBuilder: (context, index) => _OnboardingPage(step: viewModel.steps[index]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        viewModel.steps.length,
                        (index) => _IndicatorDot(isActive: index == viewModel.currentIndex),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (viewModel.isLastPage) {
                            await viewModel.complete();
                            onFinished();
                            return;
                          }
                          await viewModel.nextPage();
                        },
                        child: Text(
                          viewModel.isLastPage ? 'onboardingGetStarted'.tr() : 'onboardingNext'.tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: step.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: step.gradientColors.last.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Icon(step.icon, size: 70, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            step.titleKey.tr(),
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            step.descriptionKey.tr(),
            style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF475569)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.seedColor : const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
