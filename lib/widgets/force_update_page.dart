import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:yemek_tarifi_app/global/app_theme.dart';
import 'package:yemek_tarifi_app/widgets/app_background.dart';

/// Simple force-update screen with a pulsing background.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({
    super.key,
    required this.pulseController,
    required this.requiredVersion,
    required this.currentVersion,
    required this.storeUrl,
    required this.onTapUpdate,
  });

  final AnimationController pulseController;
  final String requiredVersion;
  final String currentVersion;
  final String storeUrl;
  final VoidCallback onTapUpdate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: AppBackground(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: pulseController,
                              builder: (context, child) {
                                final double scale =
                                    0.96 + (pulseController.value * 0.08);
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF8D6E53),
                                          Color(0xFFB65C45),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.seedColor.withValues(
                                            alpha: 0.35,
                                          ),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.system_update_alt_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                'updateRequiredTitle'.tr(),
                                key: const ValueKey<String>('update-title'),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.blueGrey.shade900,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'updateRequiredBody'.tr(
                                namedArgs: {'version': requiredVersion},
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.blueGrey.shade700,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'updateCurrentVersion'.tr(
                                namedArgs: {'version': currentVersion},
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.blueGrey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: onTapUpdate,
                                icon: const Icon(
                                  Icons.system_update_rounded,
                                  size: 20,
                                ),
                                label: Text('updateNow'.tr()),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  backgroundColor: AppTheme.seedColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              storeUrl,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.blueGrey.shade300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
