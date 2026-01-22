import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:yemek_tarifi_app/app/bootstrap/app_bootstrap_controller.dart';
import 'package:yemek_tarifi_app/app/bootstrap/splash_screen.dart';
import 'package:yemek_tarifi_app/app/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/widgets/force_update_screen.dart';
import 'package:yemek_tarifi_app/features/credits/credits_screen.dart';
import 'package:yemek_tarifi_app/features/favorites/favorites_screen.dart';
import 'package:yemek_tarifi_app/features/feedback/feedback_screen.dart';
import 'package:yemek_tarifi_app/features/home/main_screen.dart';
import 'package:yemek_tarifi_app/features/kitchen/kitchen_screen.dart';
import 'package:yemek_tarifi_app/features/onboarding/onboarding_screen.dart';
import 'package:yemek_tarifi_app/features/recipes/food_selection_screen.dart';
import 'package:yemek_tarifi_app/features/recipes/models/food.dart';
import 'package:yemek_tarifi_app/features/recipes/selected_food_screen.dart';
import 'package:yemek_tarifi_app/features/settings/settings_screen.dart';

class AppRouter {
  AppRouter(this._bootstrapController);

  final AppBootstrapController _bootstrapController;
  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: _bootstrapController,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.forceUpdate,
        builder: (context, state) {
          final data = _bootstrapController.data;
          return ForceUpdateScreen(
            requiredVersion: data?.requiredVersion ?? '',
            currentVersion: data?.localDisplayVersion ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => OnboardingScreen(
          onFinished: () async {
            await _bootstrapController.refresh();
            router.go(AppRoutes.home);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => MainScreen(
          maintenanceStatus: _bootstrapController.data?.maintenanceStatus,
        ),
      ),
      GoRoute(
        path: AppRoutes.recipes,
        builder: (context, state) => const FoodSelectionScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final int recipeId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final String category = state.uri.queryParameters['category'] ?? '';
          final Food? extraFood = state.extra is Food ? state.extra as Food : null;
          final Food startFood = extraFood ?? Food.empty();
          return SelectedFoodScreen(startFood, recipeId: recipeId, category: category);
        },
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.kitchen,
        builder: (context, state) => const KitchenScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.credits,
        builder: (context, state) => const CreditsScreen(),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        builder: (context, state) {
          final int recipeId = int.tryParse(state.uri.queryParameters['recipeId'] ?? '') ?? 0;
          final String category = state.uri.queryParameters['category'] ?? '';
          return FeedbackScreen(recipeId: recipeId, category: category);
        },
      ),
    ],
    redirect: (context, state) {
      final String path = state.uri.path;
      if (_bootstrapController.isLoading) {
        return path == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (_bootstrapController.requiresUpdate) {
        return path == AppRoutes.forceUpdate ? null : AppRoutes.forceUpdate;
      }
      if (!_bootstrapController.hasSeenOnboarding) {
        return path == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }
      if (path == AppRoutes.splash || path == AppRoutes.forceUpdate || path == AppRoutes.onboarding) {
        return AppRoutes.home;
      }
      return null;
    },
  );
}
