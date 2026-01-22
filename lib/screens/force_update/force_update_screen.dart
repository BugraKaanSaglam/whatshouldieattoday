import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yemek_tarifi_app/widgets/force_update_page.dart';

class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({
    super.key,
    required this.requiredVersion,
    required this.currentVersion,
  });

  final String requiredVersion;
  final String currentVersion;

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> with SingleTickerProviderStateMixin {
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.whatshouldieattoday.mobile';
  static const String _appStoreUrl = 'https://apps.apple.com/us/app/what-should-i-eat-today/id6741708205';

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String storeUrl = _storeUrlForDevice();

    return ForceUpdatePage(
      pulseController: _pulseController,
      requiredVersion: widget.requiredVersion,
      currentVersion: widget.currentVersion,
      storeUrl: storeUrl,
      onTapUpdate: () => _launchStoreUrl(context, storeUrl),
    );
  }

  String _storeUrlForDevice() {
    if (Platform.isIOS || Platform.isMacOS) return _appStoreUrl;
    return _playStoreUrl;
  }

  Future<void> _launchStoreUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('couldNotOpenLink'.tr())),
      );
    }
  }
}
