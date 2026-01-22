import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Minimal maintenance payload: a flag and optional localized messages.
class MaintenanceStatus {
  final bool isActive;
  final String extraMessageEn;
  final String extraMessageTr;

  const MaintenanceStatus({
    required this.isActive,
    required this.extraMessageEn,
    required this.extraMessageTr,
  });

  factory MaintenanceStatus.fromMap(Map<String, dynamic> data) {
    return MaintenanceStatus(
      isActive: data['is_active'] as bool? ?? false,
      extraMessageEn: (data['extra_message_en'] ?? '').toString().trim(),
      extraMessageTr: (data['extra_message_tr'] ?? '').toString().trim(),
    );
  }
}

/// Simple Supabase-backed maintenance checker.
class MaintenanceService {
  MaintenanceService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<MaintenanceStatus?> fetchStatus() async {
    try {
      final Map<String, dynamic>? data = await _client.from('app_maintenance').select('is_active').eq('id', 1).maybeSingle();
      if (data == null) return null;
      return MaintenanceStatus.fromMap(data);
    } catch (e) {
      // Fail open: if Supabase cannot be reached, do not block the app.
      debugPrint('Maintenance check failed: $e');
      return null;
    }
  }
}
