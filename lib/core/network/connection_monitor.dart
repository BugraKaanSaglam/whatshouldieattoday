import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:yemek_tarifi_app/core/logging/app_logger.dart';

class ConnectionMonitor extends ChangeNotifier {
  static final ConnectionMonitor shared = ConnectionMonitor();

  ConnectionMonitor({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<dynamic>? _subscription;

  bool _isOnline = true;

  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    final dynamic initialResult = await _connectivity.checkConnectivity();
    _updateStatus(initialResult, reason: 'initial');

    _subscription = _connectivity.onConnectivityChanged.listen((
      dynamic result,
    ) {
      _updateStatus(result, reason: 'stream');
    });
  }

  void _updateStatus(dynamic result, {required String reason}) {
    final List<ConnectivityResult> results = _normalizeResults(result);
    final bool nextStatus = results.any(
      (item) => item != ConnectivityResult.none,
    );

    if (nextStatus == _isOnline) return;

    _isOnline = nextStatus;
    AppLogger.i(
      'Connection status changed ($reason): ${_isOnline ? 'online' : 'offline'} '
      '[${results.map((item) => item.name).join(', ')}]',
    );
    notifyListeners();
  }

  List<ConnectivityResult> _normalizeResults(dynamic result) {
    if (result is ConnectivityResult) {
      return <ConnectivityResult>[result];
    }
    if (result is List<ConnectivityResult>) {
      return result;
    }
    if (result is List) {
      return result.whereType<ConnectivityResult>().toList();
    }
    return const <ConnectivityResult>[ConnectivityResult.none];
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
