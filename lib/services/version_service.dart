import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VersionStatus {
  final String requiredVersion;

  const VersionStatus({required this.requiredVersion});

  factory VersionStatus.fromMap(Map<String, dynamic> data) {
    final dynamic raw = data['version'] ?? data['current_version'];
    return VersionStatus(requiredVersion: (raw ?? '').toString().trim());
  }
}

/// Supabase-backed version checker that fetches the single required version row.
class VersionService {
  VersionService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<VersionStatus?> fetchRequiredVersion() async {
    try {
      final Map<String, dynamic>? data = await _client.from('current_version').select('version').eq('id', 1).maybeSingle();
      if (data == null) return null;
      final String required = VersionStatus.fromMap(data).requiredVersion;
      if (required.isEmpty) return null;
      return VersionStatus(requiredVersion: required);
    } catch (e) {
      debugPrint('Version check failed: $e');
      return null;
    }
  }
}
