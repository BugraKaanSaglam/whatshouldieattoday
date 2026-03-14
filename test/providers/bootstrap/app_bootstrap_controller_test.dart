import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/core/network/version_service.dart';
import 'package:yemek_tarifi_app/providers/bootstrap/app_bootstrap_controller.dart';

void main() {
  PackageInfo packageInfo({
    required String version,
    required String buildNumber,
  }) {
    return PackageInfo(
      appName: 'Test',
      packageName: 'yemek.tarifi.test',
      version: version,
      buildNumber: buildNumber,
    );
  }

  test('load marks update required when remote version is newer', () async {
    final controller = AppBootstrapController(
      maintenanceStatusLoader: () async => const MaintenanceStatus(
        isActive: false,
        extraMessageEn: '',
        extraMessageTr: '',
      ),
      versionStatusLoader: () async =>
          const VersionStatus(requiredVersion: '2.0.0+5'),
      onboardingSeenLoader: () async => false,
      packageInfoLoader: () async =>
          packageInfo(version: '1.4.0', buildNumber: '7'),
    );

    await controller.load();

    expect(controller.isLoading, isFalse);
    expect(controller.requiresUpdate, isTrue);
    expect(controller.hasSeenOnboarding, isFalse);
    expect(controller.data?.localVersion, '1.4.0+7');
  });

  test('refresh re-evaluates bootstrap state with latest loaders', () async {
    String requiredVersion = '1.0.0+1';

    final controller = AppBootstrapController(
      maintenanceStatusLoader: () async => const MaintenanceStatus(
        isActive: false,
        extraMessageEn: '',
        extraMessageTr: '',
      ),
      versionStatusLoader: () async =>
          VersionStatus(requiredVersion: requiredVersion),
      onboardingSeenLoader: () async => true,
      packageInfoLoader: () async =>
          packageInfo(version: '1.4.0', buildNumber: '7'),
    );

    await controller.load();
    expect(controller.requiresUpdate, isFalse);

    requiredVersion = '9.0.0+1';
    await controller.refresh();

    expect(controller.requiresUpdate, isTrue);
    expect(controller.hasSeenOnboarding, isTrue);
  });
}
