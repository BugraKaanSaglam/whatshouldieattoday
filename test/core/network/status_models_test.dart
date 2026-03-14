import 'package:flutter_test/flutter_test.dart';
import 'package:yemek_tarifi_app/core/network/maintenance_service.dart';
import 'package:yemek_tarifi_app/core/network/version_service.dart';

void main() {
  test('MaintenanceStatus.fromMap parses missing values safely', () {
    final status = MaintenanceStatus.fromMap(<String, dynamic>{
      'is_active': true,
    });

    expect(status.isActive, isTrue);
    expect(status.extraMessageEn, isEmpty);
    expect(status.extraMessageTr, isEmpty);
  });

  test('VersionStatus.fromMap trims and prioritizes version field', () {
    final status = VersionStatus.fromMap(<String, dynamic>{
      'version': ' 2.4.0+9 ',
      'current_version': '1.0.0+1',
    });

    expect(status.requiredVersion, '2.4.0+9');
  });
}
