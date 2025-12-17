// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yemek_tarifi_app/classes/favorites_class.dart';
import 'package:yemek_tarifi_app/classes/food_class.dart';
import 'package:yemek_tarifi_app/enums/categories_enum.dart';
import 'package:yemek_tarifi_app/global/global_functions.dart';
import 'package:yemek_tarifi_app/global/global_variables.dart';
import 'package:yemek_tarifi_app/screens/selectedfood_screen.dart';
import 'package:yemek_tarifi_app/services/maintenance_service.dart';
import 'package:yemek_tarifi_app/services/version_service.dart';
import 'classes/ingredient_class.dart';
import 'database/db_helper.dart';
import 'database/food_application_database.dart';
import 'enums/language_enum.dart';
import 'screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_links/app_links.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'global/app_theme.dart';
import 'data/default_ingredients.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();

  final Language deviceLanguage = _detectDeviceLanguage();

  globalDataBase = await DBHelper().getList(databaseVersion);

  if (globalDataBase == null) {
    final List<IngredientClass> defaultInitialIngredients = buildDefaultInitialIngredients();

    globalDataBase = FoodApplicationDataBase(
      ver: databaseVersion,
      languageCode: deviceLanguage.value,
      initialIngredients: List<IngredientClass>.from(defaultInitialIngredients),
      favorites: <Favorite>[],
    );
    await DBHelper().add(globalDataBase!);
    isFirstLaunch = true;
  } else {
    isFirstLaunch = false;
  }

  SupabaseConfig.ensureSet();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);

  final Language startLanguage = globalDataBase != null ? Language.getLanguageFromValue(globalDataBase!.languageCode) : deviceLanguage;
  final Locale startLocale = _languageToLocale(startLanguage);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      startLocale: startLocale,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();

  static MainAppState? of(BuildContext context) => context.findAncestorStateOfType<MainAppState>();
}

class MainAppState extends State<MainApp> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Language languageCode;
  StreamSubscription? _linkSubscription;
  late final AppLinks _appLinks;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ThemeData foodApplicationTheme = AppTheme.lightTheme;
  late Future<_BootstrapData> _bootstrapFuture;
  MaintenanceStatus? _latestMaintenanceStatus;
  bool _updateRequired = false;
  late final AnimationController _pulseController;
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.whatshouldieattoday.mobile';
  static const String _appStoreUrl = 'https://apps.apple.com/us/app/what-should-i-eat-today/id6741708205';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    WidgetsBinding.instance.addObserver(this);
    languageCode = globalDataBase != null ? Language.getLanguageFromValue(globalDataBase!.languageCode) : _detectDeviceLanguage();
    _initDeepLinkListener();
    _bootstrapFuture = _fetchBootstrapData();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _pulseController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleDeepLink(uri);
    }, onError: (err) => debugPrint(err));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        Future.delayed(const Duration(milliseconds: 500), () => _handleDeepLink(initialUri));
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if (_latestMaintenanceStatus?.isActive == true || _updateRequired) return;
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'recipe') {
      final String? recipeIdSegment = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      final int? recipeId = int.tryParse(recipeIdSegment ?? '');
      final String recipeCategory = uri.queryParameters['category'] ?? (uri.pathSegments.length > 2 ? uri.pathSegments[2] : "");
      if (recipeId != null && mounted) {
        final Food dummyFood = Food(recipeId: 0, name: "", name_tr: "", recipeCategory: CategoriesEnum.none);
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => SelectedFoodScreen(dummyFood, recipeId: recipeId, category: recipeCategory),
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_updateRequired) {
      setState(() {
        _bootstrapFuture = _fetchBootstrapData();
      });
    }
  }

  Future<_BootstrapData> _fetchBootstrapData() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String localVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    final String displayVersion = packageInfo.version;

    final maintenanceFuture = MaintenanceService().fetchStatus();
    final versionFuture = VersionService().fetchRequiredVersion();

    final MaintenanceStatus? maintenance = await maintenanceFuture;
    final VersionStatus? versionStatus = await versionFuture;

    final String? requiredVersion = versionStatus?.requiredVersion;
    final bool needsUpdate = requiredVersion != null && _compareVersions(localVersion, requiredVersion) < 0;

    if (mounted) {
      _latestMaintenanceStatus = maintenance;
      _updateRequired = needsUpdate;
    }

    return _BootstrapData(
      maintenanceStatus: maintenance,
      requiredVersion: requiredVersion,
      localVersion: localVersion,
      localDisplayVersion: displayVersion,
      requiresUpdate: needsUpdate,
    );
  }

  int _compareVersions(String current, String target) {
    List<int> parse(String value) {
      final parts = value.split(RegExp(r'[^0-9]+')).where((part) => part.isNotEmpty).map((part) => int.tryParse(part) ?? 0).toList();
      return parts.isNotEmpty ? parts : <int>[0];
    }

    final List<int> currentParts = parse(current);
    final List<int> targetParts = parse(target);
    final int maxLength = currentParts.length > targetParts.length ? currentParts.length : targetParts.length;

    for (int i = 0; i < maxLength; i++) {
      final int c = i < currentParts.length ? currentParts[i] : 0;
      final int t = i < targetParts.length ? targetParts[i] : 0;
      if (c != t) return c.compareTo(t);
    }
    return 0;
  }

  Future<void> setLocale(Language language) async {
    final locale = _toLocale(language);
    await context.setLocale(locale);
    if (mounted) {
      setState(() {
        languageCode = language;
      });
    }
    if (globalDataBase != null) {
      globalDataBase!.languageCode = language.value;
      await DBHelper().update(globalDataBase!);
    }
  }

  Locale _toLocale(Language lang) {
    switch (lang) {
      case Language.turkish:
        return const Locale('tr', 'TR');
      case Language.english:
        return const Locale('en', 'US');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: foodApplicationTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<_BootstrapData>(
        future: _bootstrapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
            return _buildMaintenanceLoading(context);
          }
          final _BootstrapData data = snapshot.data ?? const _BootstrapData(localVersion: '0.0.0', localDisplayVersion: '0.0.0', requiresUpdate: false);

          if (data.requiresUpdate) {
            return _buildForceUpdate(context, data);
          }

          return MainScreen(maintenanceStatus: data.maintenanceStatus);
        },
      ),
      locale: context.locale,
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      localizationsDelegates: context.localizationDelegates,
    );
  }

  Widget _buildMaintenanceLoading(BuildContext context) {
    return globalScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text('loading'.tr(), style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildForceUpdate(BuildContext context, _BootstrapData data) {
    final theme = Theme.of(context);
    final String latest = data.requiredVersion ?? '';
    final String current = data.localDisplayVersion;
    final String storeUrl = _storeUrlForDevice();

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final double shift = (_pulseController.value * 0.2) - 0.1;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + shift, -1),
                      end: Alignment(1 - shift, 1),
                      colors: const [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                    ),
                  ),
                );
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 28, offset: const Offset(0, 16))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final double scale = 0.96 + (_pulseController.value * 0.08);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)]),
                                    boxShadow: [BoxShadow(color: AppTheme.seedColor.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 10))],
                                  ),
                                  child: const Icon(Icons.system_update_alt_rounded, size: 48, color: Colors.white),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              'updateRequiredTitle'.tr(),
                              key: ValueKey<String>('update-title'),
                              style: theme.textTheme.headlineSmall?.copyWith(color: Colors.blueGrey.shade900, fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'updateRequiredBody'.tr(namedArgs: {'version': latest}),
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.blueGrey.shade700, height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'updateCurrentVersion'.tr(namedArgs: {'version': current}),
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade500),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _launchStoreUrl(storeUrl),
                              icon: const Icon(Icons.system_update_rounded, size: 20),
                              label: Text('updateNow'.tr()),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: AppTheme.seedColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchStoreUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(navigatorKey.currentContext ?? context).showSnackBar(
          SnackBar(content: Text('couldNotOpenLink'.tr())),
        );
      }
    }
  }

  String _storeUrlForDevice() {
    if (Platform.isIOS || Platform.isMacOS) return _appStoreUrl;
    return _playStoreUrl;
  }
}

class _BootstrapData {
  final MaintenanceStatus? maintenanceStatus;
  final String? requiredVersion;
  final String localVersion;
  final String localDisplayVersion;
  final bool requiresUpdate;

  const _BootstrapData({
    this.maintenanceStatus,
    this.requiredVersion,
    required this.localVersion,
    required this.localDisplayVersion,
    required this.requiresUpdate,
  });
}

Language _detectDeviceLanguage() {
  final Locale deviceLocale = PlatformDispatcher.instance.locale;
  final String code = deviceLocale.languageCode.toLowerCase();
  if (code == 'tr') return Language.turkish;
  return Language.english;
}

Locale _languageToLocale(Language lang) {
  switch (lang) {
    case Language.turkish:
      return const Locale('tr', 'TR');
    case Language.english:
      return const Locale('en', 'US');
  }
}
