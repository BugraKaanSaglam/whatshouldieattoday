import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/providers/bootstrap/app_bootstrap_controller.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_router.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';
import 'package:yemek_tarifi_app/core/network/version_service.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';

class FoodApp extends StatefulWidget {
  const FoodApp({super.key});

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> with WidgetsBindingObserver {
  late final AppBootstrapController _bootstrapController;
  late final AppRouter _appRouter;
  StreamSubscription<Uri?>? _linkSubscription;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _bootstrapController = AppBootstrapController(
      maintenanceService: MaintenanceService(),
      versionService: VersionService(),
      onboardingService: OnboardingService(),
    )..load();
    _appRouter = AppRouter(_bootstrapController);

    WidgetsBinding.instance.addObserver(this);
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _bootstrapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_bootstrapController.requiresUpdate) {
      _bootstrapController.refresh();
    }
  }

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(uri);
    }, onError: (err) => debugPrint(err.toString()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        Future.delayed(const Duration(milliseconds: 500), () => _handleDeepLink(initialUri));
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if (_bootstrapController.requiresUpdate || _bootstrapController.data?.maintenanceStatus?.isActive == true) return;
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'recipe') {
      final String? recipeIdSegment = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      final int? recipeId = int.tryParse(recipeIdSegment ?? '');
      final String category = uri.queryParameters['category'] ?? (uri.pathSegments.length > 2 ? uri.pathSegments[2] : '');
      if (recipeId != null) {
        _appRouter.router.push('${AppRoutes.recipeById(recipeId)}?category=$category');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.router,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
