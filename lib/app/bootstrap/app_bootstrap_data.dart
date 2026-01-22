import 'package:yemek_tarifi_app/core/services/maintenance_service.dart';

class AppBootstrapData {
  final MaintenanceStatus? maintenanceStatus;
  final String? requiredVersion;
  final String localVersion;
  final String localDisplayVersion;
  final bool requiresUpdate;
  final bool hasSeenOnboarding;

  const AppBootstrapData({
    this.maintenanceStatus,
    this.requiredVersion,
    required this.localVersion,
    required this.localDisplayVersion,
    required this.requiresUpdate,
    required this.hasSeenOnboarding,
  });
}
