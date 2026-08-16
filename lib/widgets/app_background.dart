import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';

/// Shared screen background used below each screen's app bar.
///
/// The image is intentionally covered by a warm, translucent scrim so that
/// foreground cards, labels, and controls remain readable on every device
/// size while the food imagery still gives the app a consistent identity.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final int cacheWidth = (mediaQuery.size.width * mediaQuery.devicePixelRatio)
            .clamp(480.0, 720.0)
        .round();
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: Image.asset(
            'assets/images/screen_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            cacheWidth: cacheWidth,
            filterQuality: FilterQuality.medium,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.parchment.withValues(alpha: 0.88),
                AppTheme.parchment.withValues(alpha: 0.78),
                AppTheme.surfaceMuted.withValues(alpha: 0.86),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
