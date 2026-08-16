import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/providers/bootstrap/app_bootstrap_controller.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_routes.dart';
import 'package:yemek_tarifi_app/core/configs/router/app_router.dart';
import 'package:yemek_tarifi_app/core/logging/app_logger.dart';
import 'package:yemek_tarifi_app/core/network/connection_monitor.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';
import 'package:yemek_tarifi_app/core/network/version_service.dart';
import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/widgets/connectivity_status_banner.dart';

class FoodApp extends StatefulWidget {
  const FoodApp({super.key});

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> with WidgetsBindingObserver {
  late final AppBootstrapController _bootstrapController;
  late final AppRouter _appRouter;
  late final ConnectionMonitor _connectionMonitor;
  StreamSubscription<Uri?>? _linkSubscription;
  Timer? _deepLinkTimer;
  late final AppLinks _appLinks;
  bool _lastKnownOnline = true;

  @override
  void initState() {
    super.initState();
    _connectionMonitor = ConnectionMonitor.shared
      ..addListener(_handleConnectionStatusChanged);
    unawaited(_connectionMonitor.initialize());
    _bootstrapController = AppBootstrapController(
      maintenanceService: MaintenanceService(),
      versionService: VersionService(),
      onboardingService: OnboardingService(),
    )..load();
    _appRouter = AppRouter(_bootstrapController);

    WidgetsBinding.instance.addObserver(this);
    unawaited(_initDeepLinkListener());
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _deepLinkTimer?.cancel();
    _connectionMonitor
      ..removeListener(_handleConnectionStatusChanged)
      ..dispose();
    _bootstrapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !_bootstrapController.requiresUpdate) {
      _bootstrapController.refresh();
    }
  }

  Future<void> _initDeepLinkListener() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (mounted && uri != null) _handleDeepLink(uri);
    }, onError: (err) => AppLogger.w('Deep link stream error', err));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (!mounted || initialUri == null) return;
      _deepLinkTimer?.cancel();
      _deepLinkTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) _handleDeepLink(initialUri);
      });
    });
  }

  void _handleConnectionStatusChanged() {
    final bool isOnline = _connectionMonitor.isOnline;
    if (isOnline == _lastKnownOnline) return;

    final bool restoredConnection = !_lastKnownOnline && isOnline;
    _lastKnownOnline = isOnline;

    if (restoredConnection && !_bootstrapController.requiresUpdate) {
      unawaited(_bootstrapController.refresh());
    }
  }

  void _handleDeepLink(Uri uri) {
    if (_bootstrapController.requiresUpdate ||
        _bootstrapController.data?.maintenanceStatus?.isActive == true) {
      return;
    }
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'recipe') {
      final String? recipeIdSegment = uri.pathSegments.length > 1
          ? uri.pathSegments[1]
          : null;
      final int? recipeId = int.tryParse(recipeIdSegment ?? '');
      final String category =
          uri.queryParameters['category'] ??
          (uri.pathSegments.length > 2 ? uri.pathSegments[2] : '');
      if (recipeId != null) {
        _appRouter.router.push(
          '${AppRoutes.recipeById(recipeId)}?category=$category',
        );
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
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _connectionMonitor,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                child ?? const SizedBox(),
                ConnectivityStatusBanner(isOnline: _connectionMonitor.isOnline),
              ],
            );
          },
        );
      },
    );
  }
}

/// Visible fallback for local launches that did not pass the public Supabase
/// build configuration. This prevents the native splash screen from looking
/// frozen while the async entrypoint has already terminated.
class SupabaseConfigErrorApp extends StatelessWidget {
  const SupabaseConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Configuration required')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supabase configuration is missing.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Create supabase.env or tool/config/supabase.local.json '
                      'with the public project URL and publishable key, then '
                      'restart the app.',
                    ),
                    const SizedBox(height: 20),
                    const SelectableText(
                      'dart run tool/prepare_supabase_config.dart',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'VS Code launch profiles prepare this file automatically. '
                      'For Android Studio, run the command once before pressing '
                      'Run.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
