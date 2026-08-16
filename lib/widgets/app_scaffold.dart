import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/widgets/app_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, this.appBar, this.body, this.bottomBar});

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFFFFAF2),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: AppBackground(child: body ?? const SizedBox()),
          ),
          bottomNavigationBar: bottomBar == null
              ? null
              : DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppTheme.appBarGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: bottomBar,
                ),
        ),
      ),
    );
  }
}
