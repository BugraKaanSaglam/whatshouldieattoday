import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/widgets/app_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
}
