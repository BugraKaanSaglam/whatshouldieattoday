import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:yemek_tarifi_app/models/bootstrap/app_bootstrap_data.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/core/network/onboarding_service.dart';
import 'package:yemek_tarifi_app/core/network/version_service.dart';

class AppBootstrapController extends ChangeNotifier {
  AppBootstrapController({
    required MaintenanceService maintenanceService,
    required VersionService versionService,
    required OnboardingService onboardingService,
  })  : _maintenanceService = maintenanceService,
        _versionService = versionService,
        _onboardingService = onboardingService;

  final MaintenanceService _maintenanceService;
  final VersionService _versionService;
  final OnboardingService _onboardingService;

  AppBootstrapData? _data;
  bool _isLoading = true;

  AppBootstrapData? get data => _data;
  bool get isLoading => _isLoading;
  bool get requiresUpdate => _data?.requiresUpdate ?? false;
  bool get hasSeenOnboarding => _data?.hasSeenOnboarding ?? true;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _data = await _fetchBootstrapData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _data = await _fetchBootstrapData();
    notifyListeners();
  }

  Future<AppBootstrapData> _fetchBootstrapData() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String localVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    final String displayVersion = packageInfo.version;

    final maintenanceFuture = _maintenanceService.fetchStatus();
    final versionFuture = _versionService.fetchRequiredVersion();
    final onboardingFuture = _onboardingService.hasSeenOnboarding();

    final MaintenanceStatus? maintenance = await maintenanceFuture;
    final VersionStatus? versionStatus = await versionFuture;
    final bool hasSeenOnboarding = await onboardingFuture;

    final String? requiredVersion = versionStatus?.requiredVersion;
    final bool needsUpdate = requiredVersion != null && _compareVersions(localVersion, requiredVersion) < 0;

    return AppBootstrapData(
      maintenanceStatus: maintenance,
      requiredVersion: requiredVersion,
      localVersion: localVersion,
      localDisplayVersion: displayVersion,
      requiresUpdate: needsUpdate,
      hasSeenOnboarding: hasSeenOnboarding,
    );
  }

  int _compareVersions(String current, String target) {
    List<int> parse(String value) {
      final parts = value
          .split(RegExp(r'[^0-9]+'))
          .where((part) => part.isNotEmpty)
          .map((part) => int.tryParse(part) ?? 0)
          .toList();
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
}
