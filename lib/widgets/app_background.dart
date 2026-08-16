import 'package:flutter/material.dart';

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
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: Image.asset(
            'assets/images/screen_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const ColoredBox(color: Color(0xCFFFFAF2)),
        child,
      ],
    );
  }
}
