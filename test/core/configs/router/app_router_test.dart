import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_router.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';

void main() {
  group('AppRouter.resolveRedirect', () {
    test('keeps splash route while bootstrap is loading', () {
      final result = AppRouter.resolveRedirect(
        isLoading: true,
        requiresUpdate: false,
        hasSeenOnboarding: false,
        path: AppRoutes.splash,
      );

      expect(result, isNull);
    });

    test('redirects to splash while bootstrap is loading', () {
      final result = AppRouter.resolveRedirect(
        isLoading: true,
        requiresUpdate: false,
        hasSeenOnboarding: false,
        path: AppRoutes.home,
      );

      expect(result, AppRoutes.splash);
    });

    test('redirects to force update when version gate is active', () {
      final result = AppRouter.resolveRedirect(
        isLoading: false,
        requiresUpdate: true,
        hasSeenOnboarding: true,
        path: AppRoutes.home,
      );

      expect(result, AppRoutes.forceUpdate);
    });

    test('redirects to onboarding when it is not completed', () {
      final result = AppRouter.resolveRedirect(
        isLoading: false,
        requiresUpdate: false,
        hasSeenOnboarding: false,
        path: AppRoutes.home,
      );

      expect(result, AppRoutes.onboarding);
    });

    test(
      'returns home when bootstrap routes are opened after app is ready',
      () {
        for (final path in <String>[
          AppRoutes.splash,
          AppRoutes.forceUpdate,
          AppRoutes.onboarding,
        ]) {
          final result = AppRouter.resolveRedirect(
            isLoading: false,
            requiresUpdate: false,
            hasSeenOnboarding: true,
            path: path,
          );

          expect(result, AppRoutes.home);
        }
      },
    );

    test('allows regular routes when app is ready', () {
      final result = AppRouter.resolveRedirect(
        isLoading: false,
        requiresUpdate: false,
        hasSeenOnboarding: true,
        path: AppRoutes.favorites,
      );

      expect(result, isNull);
    });
  });
}
